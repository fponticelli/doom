package doom;

using thx.Arrays;
using thx.Functions;
using thx.Ints;
using thx.Iterators;
using thx.Strings;
using thx.Set;
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

  inline public static function comment(content : String) : Node
    return Comment(content);

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
        common.filter.fn(a.get(_) != b.get(_))
          .map.fn(Patch.SetAttribute(_, b.get(_))))
      .concat(added.map.fn(Patch.SetAttribute(_, b.get(_))));
  }

  static function diffAdd(node : Node) : Array<Patch>
    return switch node {
      case Element(n, a, c):
        [AddElement(n, a, c)];
      case Text(t):
        [AddText(t)];
      case Raw(t):
        [AddRaw(t)];
      case Comment(t):
        [AddComment(t)];
      case ComponentNode(comp):
        [AddComponent(comp)];
    };

  public static function diffNodes(a : Array<Node>, b : Array<Node>) : Array<Patch> {
    var min = a.length.min(b.length),
        result : Array<Patch> = [];
    for(i in min...a.length) {
      result.push(PatchChild(a.length - i, [Remove]));
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
    return switch [this, that] {
      case [ComponentNode(old), ComponentNode(comp)]:
        [ReplaceWithComponent(comp)];
      case [_, ComponentNode(comp)]:
        [ReplaceWithComponent(comp)];
      case [Element(n1, a1, c1), Element(n2, a2, c2)] if(n1 != n2):
        [ReplaceWithElement(n2, a2, c2)];
      case [Element(_, a1, c1), Element(_, a2, c2)]:
        diffAttributes(a1, a2)
          .concat(diffNodes(c1, c2));
      case [_, Element(n2, a2, c2)]:
        [ReplaceWithElement(n2, a2, c2)];
      case [Text(t1), Text(t2)] | [Comment(t1), Comment(t2)] if(t1 != t2):
        [ContentChanged(t2)];
      case [Text(_), Text(_)] | [Comment(_), Comment(_)]:
        [];
      case [_, Text(t)]:
        [ReplaceWithText(t)];
      case [_, Raw(t)]:
        [ReplaceWithRaw(t)];
      case [_, Comment(t)]:
        [ReplaceWithComment(t)];
    };
  }

  @:to public function toString() : String
    return doom.XmlNode.toString(this);
}

enum NodeImpl {
  Element(
    name : String,
    attributes : Map<String, AttributeValue>,
    children : Array<Node>);
  Raw(text : String);
  Text(text : String);
  Comment(text : String);
  ComponentNode(comp : IComponent);
}
