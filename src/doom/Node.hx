package doom;

import thx.OrderedMap;

enum Node {
  Element(
    name : String,
    attributes : OrderedMap<String, String>,
    events : OrderedMap<String, EventHandler>,
    children : Array<Node>);
  Text(text : String);
  Comment(text : String);
  Empty;
}
