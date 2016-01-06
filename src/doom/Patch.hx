package doom;

using thx.Arrays;
using thx.Iterators;
using thx.Maps;

enum Patch {
  AddText(text : String);
  AddRaw(text : String);
  AddElement(
    name : String,
    attributes : Map<String, AttributeValue>,
    children : Array<Node>);
  AddComponent(comp : IComponent);
  DestroyComponent(comp : IComponent);
  MigrateComponentToComponent(oldComp : IComponent, newComp : IComponent);
  MigrateElementToComponent(comp : IComponent);
  Remove;
  RemoveAttribute(name : String);
  SetAttribute(name : String, value : AttributeValue);
  ReplaceWithElement(
    name : String,
    attributes : Map<String, AttributeValue>,
    children : Array<Node>);
  ReplaceWithText(text : String);
  ReplaceWithRaw(raw : String);
  ReplaceWithComponent(comp : IComponent);
  ContentChanged(newcontent : String);
  PatchChild(index : Int, patches : Array<Patch>);
}

class Patches {
  public static function toString(patch : Patch) return switch patch {
    case AddElement(name, attributes, children):
      var c = children.map(function(child) return "\n  " + child.toString().split("\n").join("\n  "));
      return 'AddElement($name, ${attributes.string()}, $c)';
    case ReplaceWithElement(name, attributes, children):
      var c = children.map(function(child) return "\n  " + child.toString().split("\n").join("\n  "));
      return 'ReplaceWithElement($name, ${attributes.string()}, $c)';
    case AddComponent(comp):
      return 'AddComponent(${comp.toString()})';
    case ReplaceWithComponent(comp):
      return 'ReplaceWithComponent(${comp.toString()})';
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
