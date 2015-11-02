package doom;

enum Patch {
  AddText(text : String);
  AddComment(text : String);
  AddElement(
    name : String,
    attributes : Map<String, String>,
    events : Map<String, EventHandler>,
    children : Array<Node>);
  Remove;
  RemoveAttribute(name : String);
  SetAttribute(name : String, value : String);
  RemoveEvent(name : String);
  SetEvent(name : String, handler : EventHandler);
  ReplaceWithElement(
    name : String,
    attributes : Map<String, String>,
    events : Map<String, EventHandler>,
    children : Array<Node>);
  ReplaceWithText(text : String);
  ReplaceWithComment(text : String);
  ContentChanged(newcontent : String);
  PatchChild(index : Int, patches : Array<Patch>);
}
