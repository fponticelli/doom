package doom;

import thx.OrderedMap;

abstract Node(NodeImpl) from NodeImpl to NodeImpl {
  public function diff(that : Node) : Array<Patch> {
    return switch [this, that] {
      case [Element(n1, a1, e1, c1), Element(n2, a2, e2, c2)] if(n1 != n2):
        [ReplaceWithElement(n2, a2, e2, c2)];
      case [Element(_, a1, e1, c1), Element(_, a2, e2, c2)]:
        diffAttributes(a1, a2)
          .concat(diffEvents(e1, e2))
          .concat(diffChildren(c1, c2));
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

  public static function diffAttributes(a : OrderedMap<String, String>, b : OrderedMap<String, String>) : Array<Patch> {
    return [];
  }

  public static function diffEvents(a : OrderedMap<String, EventHandler>, b : OrderedMap<String, EventHandler>) : Array<Patch> {
    return [];
  }

  public static function diffChildren(a : Array<Node>, b : Array<Node>) : Array<Patch> {
    return [];
  }
}

enum NodeImpl {
  Element(
    name : String,
    attributes : OrderedMap<String, String>,
    events : OrderedMap<String, EventHandler>,
    children : Array<Node>);
  Text(text : String);
  Comment(text : String);
  Empty;
}
