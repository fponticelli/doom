package doom;

using thx.Arrays;
using thx.Functions;
using thx.Ints;
using thx.Iterators;
using thx.Strings;
using thx.Set;

abstract Node(NodeImpl) from NodeImpl to NodeImpl {
  public function diff(that : Node) : Array<Patch> {
    return switch [this, that] {
      case [Element(n1, a1, e1, c1), Element(n2, a2, e2, c2)] if(n1 != n2):
        [ReplaceWithElement(n2, a2, e2, c2)];
      case [Element(_, a1, e1, c1), Element(_, a2, e2, c2)]:
        diffAttributes(a1, a2)
          .concat(diffEvents(e1, e2))
          .concat(diffNodes(c1, c2));
      case [_, Element(n2, a2, e2, c2)]:
        [ReplaceWithElement(n2, a2, e2, c2)];
      case [Text(t1), Text(t2)] | [Comment(t1), Comment(t2)] if(t1 != t2):
        [ContentChanged(t2)];
      case [Text(_), Text(_)] | [Comment(_), Comment(_)] | [Empty, Empty]:
        [];
      case [_, Text(t)]:
        [ReplaceWithText(t)];
      case [_, Comment(t)]:
        [ReplaceWithComment(t)];
      case [_, Empty]: // TODO is this needed?
        [Patch.Remove];
    };
  }

  public static function diffAttributes(a : Map<String, String>, b : Map<String, String>) : Array<Patch> {
    var ka = Set.createString(a.keys().toArray()),
        kb = Set.createString(b.keys().toArray()),
        removed = ka.difference(kb),
        added   = kb.difference(ka),
        common  = ka.intersection(kb);

    return removed.map.fn(Patch.RemoveAttribute(_))
      .concat(common.filter.fn(a.get(_) != b.get(_)).map.fn(Patch.SetAttribute(_, b.get(_))))
      .concat(added.map.fn(Patch.SetAttribute(_, b.get(_))));
  }

  public static function diffEvents(a : Map<String, EventHandler>, b : Map<String, EventHandler>) : Array<Patch> {
    var ka = Set.createString(a.keys().toArray()),
        kb = Set.createString(b.keys().toArray()),
        removed = ka.difference(kb).toArray(),
        added   = kb.difference(ka).toArray(),
        common  = ka.intersection(kb).toArray();

    return removed.map.fn(Patch.RemoveEvent(_))
      .concat(common.filter.fn(a.get(_) != b.get(_)).map.fn(Patch.SetEvent(_, b.get(_))))
      .concat(added.map.fn(Patch.SetEvent(_, b.get(_))));
  }

  public static function diffNodes(a : Array<Node>, b : Array<Node>) : Array<Patch> {
    var min = a.length.min(b.length),
        result = [];
    for(i in min...a.length) {
      result.push(Patch.PatchChild(i, [Remove]));
    }
    for(i in min...b.length) {
      switch b[i] {
        case Element(n, a, e, c):
          result.push(PatchChild(i, [AddElement(n, a, e, c)]));
        case Text(t):
          result.push(PatchChild(i, [AddText(t)]));
        case Comment(t):
          result.push(PatchChild(i, [AddComment(t)]));
        case Empty:
          // do nothing
      };
    }
    for(i in 0...min) {
      var diff = a[i].diff(b[i]);
      if(diff.length > 0)
        result.push(PatchChild(i, diff));
    }
    return result;
  }
}

enum NodeImpl {
  Element(
    name : String,
    attributes : Map<String, String>,
    events : Map<String, EventHandler>,
    children : Array<Node>);
  Text(text : String);
  Comment(text : String);
  Empty;
}
