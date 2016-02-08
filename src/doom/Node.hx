package doom;

using thx.Arrays;
using thx.Functions;
using thx.Ints;
using thx.Iterators;
using thx.Strings;
using thx.Set;
import thx.Types;
import doom.AttributeValue;

abstract Node(NodeImpl) from NodeImpl to NodeImpl {
  public static function el(name : String,
    ?attributes : Map<String, AttributeValue>,
    ?children : Array<Node>,
    ?child : Node) : Node {
    if(null == attributes)
      attributes = new Map();
    if(null == children)
      children = [];
    if(null != child)
      children.push(child);
    return Element(name, attributes, children);
  }

  @:from
  inline public static function text(content : String) : Node
    return Text(content);

  inline public static function raw(content : String) : Node
    return Raw(content);

  @:from
  inline public static function comp(comp : IComponent) : Node
    return ComponentNode(comp);

  public static function diffAttributes(a : Map<String, AttributeValue>, b : Map<String, AttributeValue>) : Array<Patch> {
    var ka = Set.createString(a.keys().toArray()),
        kb = Set.createString(b.keys().toArray()),
        removed = ka.difference(kb),
        added   = kb.difference(ka),
        common  = ka.intersection(kb);

    return removed.map.fn(Patch.RemoveAttribute(_))
      .concat(
        common
          .filter.fn(a.get(_) != b.get(_))
          .map(function(k) {
            var v = b.get(k);
            return null == v ? Patch.RemoveAttribute(k) : Patch.SetAttribute(k, v);
          }))
      .concat(added
        .filter.fn(b.get(_) != null)
        .map.fn(Patch.SetAttribute(_, b.get(_))));
  }

  static function diffAdd(node : Node) : Array<Patch>
    return switch node {
      case Element(n, a, c):
        [AddElement(n, a, c)];
      case Text(t):
        [AddText(t)];
      case Raw(t):
        [AddRaw(t)];
      case ComponentNode(comp):
        [AddComponent(comp)];
    };

  public static function diffNodes(a : Array<Node>, b : Array<Node>) : Array<Patch> {
    var min = a.length.min(b.length),
        result : Array<Patch> = [],
        counter = 0;
    for(i in min...a.length) {
      result.push(PatchChild(a.length - (++counter), [Remove]));
    }
    for(i in min...b.length) {
      result = result.concat(diffAdd(b[i]));
    }
    for(i in 0...min) {
      var diff = a[i].diff(b[i]);
      if(diff.length > 0)
        result.push(PatchChild(i, diff));
    }
    return result;
  }

  public function diff(that : Node) : Array<Patch> {
    function destroySubComponents(node) : Array<Patch> {
      return switch node {
        case ComponentNode(comp):
          [Patch.DestroyComponent(comp)].concat(destroySubComponents(comp.node));
        case _:
          [];
      };
    }

    var p : Array<Patch> = switch [this, that] {
      case [ComponentNode(old), ComponentNode(comp)]:
        [MigrateComponentToComponent(old, comp)];
      case [_, ComponentNode(comp)]:
        [MigrateElementToComponent(comp)];
      case [ComponentNode(comp), _]:
        destroySubComponents(this);
      case [_, _]:
        [];
    };

    return p.concat(switch [this, that] {
      case [ComponentNode(old), ComponentNode(comp)]:
        old.node.diff(comp.node);
      case [_, ComponentNode(comp)]:
        [ReplaceWithComponent(comp)];
      case [Element(n1, a1, c1), Element(n2, a2, c2)] if(n1 != n2):
        [ReplaceWithElement(n2, a2, c2)];
      case [Element(_, a1, c1), Element(_, a2, c2)]:
        diffAttributes(a1, a2)
          .concat(diffNodes(c1, c2));
      case [Text(_), Element(n2, a2, c2)]:
        [ReplaceWithElement(n2, a2, c2)];
      case [_, Element(n2, a2, c2)]:
        [ReplaceWithElement(n2, a2, c2)];
      case [Text(t1), Text(t2)] if(t1 != t2):
        [ContentChanged(t2)];
      case [Text(a), Text(b)] if(a == b):
        [];
      case [_, Text(t)]:
        [ReplaceWithText(t)];
      case [Raw(a), Raw(b)] if(a == b):
        [];
      case [_, Raw(t)]:
        [ReplaceWithRaw(t)];
    });
  }

  public function toString() : String
    return doom.XmlNode.toString(this);
}

@:forward(length, concat, copy, filter, indexOf, iterator, join, lastIndexOf,
          map, slice)
abstract Nodes(Array<Node>) from Array<Node> to Array<Node> {
  @:from inline public static function fromNode(node : Node) : Nodes
    return [node];

  @:from inline public static function fromNodeImpl(node : NodeImpl) : Nodes
    return [(node : Node)];

  @:from inline public static function fromIComps(comps : Array<IComponent>) : Nodes
    return comps.map(Node.comp);

  @:from
  inline public static function fromComps<Api, State>(comps : Array<Component<Api, State>>) : Nodes
    return comps.map(Node.comp);

  @:from
  inline public static function text(content : String) : Nodes
    return [Text(content)];

  @:from
  inline public static function comp<Api, State>(comp : Component<Api, State>) : Nodes
    return [(ComponentNode(comp) : Node)];

  public function toString()
    return this.map(function(c) return c.toString()).join("\n");
}

enum NodeImpl {
  Element(
    name : String,
    attributes : Map<String, AttributeValue>,
    children : Array<Node>);
  Raw(text : String);
  Text(text : String);
  ComponentNode(comp : IComponent);
}
