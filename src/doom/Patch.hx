package doom;

import thx.OrderedMap;

enum Patch {
  Remove;
  ReplaceWithElement(
    name : String,
    attributes : OrderedMap<String, String>,
    events : OrderedMap<String, EventHandler>,
    children : Array<Node>);
  ReplaceWithText(text : String);
  ReplaceWithComment(text : String);
  ContentChanged(newcontent : String);
  PatchChild(index : Int, patch : Patch);
}
