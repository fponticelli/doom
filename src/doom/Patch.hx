package doom;

using thx.Arrays;
using thx.Iterators;
using thx.Maps;

enum Patch {
  AddText(text : String);
  AddRaw(text : String);
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
  ReplaceWithRaw(text : String);
  ReplaceWithComment(text : String);
  ContentChanged(newcontent : String);
  PatchChild(index : Int, patches : Array<Patch>);
}

class Patches {
  public static function toString(patch : Patch) return switch patch {
    case AddElement(name, attributes, events, children):
      var e = events.keys().toArray().toString(),
          c = children.map(function(child) return "\n  " + child.toString().split("\n").join("\n  "));
      return 'AddElement($name, ${attributes.string()}, $e, $c)';
    case ReplaceWithElement(name, attributes, events, children):
      var e = events.keys().toArray().toString(),
          c = children.map(function(child) return "\n  " + child.toString().split("\n").join("\n  "));
      return 'ReplaceWithElement($name, ${attributes.string()}, $e, $c)';
    case SetEvent(name, handler):
      return 'SetEvent($name, ƒ)';
    case PatchChild(index, patches):
      var p = "  " + PatchArray.toPrettyString(patches).split("\n").join("\n  ");
      return 'PatchChild($index, $p)';
    case _:
      Std.string(patch);
  }
}

class PatchArray {
  public static function toPrettyString(patches : Array<Patch>)
    return "\n" + patches.map(Patches.toString).join("\n");
}
