package doom;

using thx.Functions;
using thx.Strings;
import doom.Node;

class XmlNode {
  public static function toXml(node : Node) return switch (node : NodeImpl) {
    case Element(name, attributes, events, children):
      var xml = Xml.createElement(name);
      for(key in attributes.keys())
        xml.set(key, attributes.get(key));
      for(child in children) {
        var n = toXml(child);
        if(null != n)
          xml.addChild(n);
      }
      xml;
    case Text(text): Xml.createCData(text);
    case Comment(text): Xml.createComment(text);
    case Empty: null;
  };

  public static function applyPatches(patches : Array<Patch>, node : js.html.Node)
    for(patch in patches)
      applyPatch(patch, node);

  public static function applyPatch(patch : Patch, node : js.html.Node) switch [patch, node.nodeType] {
    case [AddText(text), _]:
    case [AddComment(text), _]:
    case [AddElement(name, attributes, events, children), _]:
    case [Remove, _]:
    case [RemoveAttribute(name), _]:
    case [SetAttribute(name, value), _]:
    case [RemoveEvent(name), _]:
    case [SetEvent(name, handler), _]:
    case [ReplaceWithElement(name, attributes, events, children), _]:
    case [ReplaceWithText(text), _]:
    case [ReplaceWithComment(text), _]:
    case [ContentChanged(newcontent), _]:
    case [PatchChild(index, patch), _]:
  };

  public static function toString(node : Node) return switch (node : NodeImpl) {
    case Element(name, attributes, events, children):
      var buf = '<$name${attributesToString(attributes)}';
      if(children.length == 0)
        buf += '/>';
      else {
        buf += '>';
        buf += children.map.fn(toString(_)).join("");
        buf += '</$name>';
      }
      buf;
    case Text(text): text;
    case Comment(text): '<!--$text-->';
    case Empty: "";
  };

  public static function attributesToString(attributes : Map<String, String>) {
    var buf = "";
    for(key in attributes.keys()) {
      buf += ' $key="${attributes.get(key).replace('"', '&quot;')}"';
    }
    return buf;
  }
}
