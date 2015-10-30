package doom;

import thx.OrderedMap;

abstract Node(NodeImpl) from NodeImpl to NodeImpl {
  public function diff(that : Node) : Array<Patch> {
    return switch [this, that] {

      case [Empty, Empty]:
        [];
      case [_, _]:
        throw new thx.Error('pattern not implemented yet [$this, $that]');
    };
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
