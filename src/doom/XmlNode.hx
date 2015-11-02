package doom;

using thx.Functions;
using thx.Strings;
using thx.Iterators;
import doom.Node;

class XmlNode {
  public static function toXml(node : Node) return switch (node : NodeImpl) {
    case Element(name, attributes, events, children):
      createElement(name, attributes, events, children);
    case Text(text): Xml.createPCData(text);
    case Comment(text): Xml.createComment(text);
    case Empty: null;
  };

  static function createElement(name : String, attributes : Map<String, String>, events : Map<String, EventHandler>, children : Array<Node>) {
    var xml = Xml.createElement(name);
    for(key in attributes.keys())
      xml.set(key, attributes.get(key));
    for(child in children) {
      var n = toXml(child);
      if(null != n)
        xml.addChild(n);
    }
    return xml;
  }

  public static function applyPatches(patches : Array<Patch>, node : Xml)
    for(patch in patches)
      applyPatch(patch, node);

  public static function applyPatch(patch : Patch, node : Xml) switch [patch, node.nodeType] {
    case [AddText(text), Xml.Element]:
      node.addChild(Xml.createPCData(text));
    case [AddComment(text), Xml.Element]:
      node.addChild(Xml.createComment(text));
    case [AddElement(name, attributes, events, children), Xml.Element]:
      node.addChild(createElement(name, attributes, events, children));
    case [Remove, _]:
      node.parent.removeChild(node);
    case [RemoveAttribute(name), Xml.Element]:
      node.remove(name);
    case [SetAttribute(name, value), Xml.Element]:
      node.set(name, value);
    case [RemoveEvent(name), Xml.Element]:
      // not implemented for XML
    case [SetEvent(name, handler), Xml.Element]:
      // not implemented for XML
    case [ReplaceWithElement(name, attributes, events, children), _]:
      var parent = node.parent,
          pos = parent.iterator().indexOf(node);
      parent.removeChild(node);
      parent.insertChild(createElement(name, attributes, events, children), pos);
    case [ReplaceWithText(text), _]:
      var parent = node.parent,
          pos = parent.iterator().indexOf(node);
      parent.removeChild(node);
      parent.insertChild(Xml.createPCData(text), pos);
    case [ReplaceWithComment(text), _]:
      var parent = node.parent,
          pos = parent.iterator().indexOf(node);
      parent.removeChild(node);
      parent.insertChild(Xml.createComment(text), pos);
    case [ContentChanged(newcontent), Xml.CData]
       | [ContentChanged(newcontent), Xml.Comment]:
      node.nodeValue = newcontent;
    case [PatchChild(index, patches), Xml.Element]:
      var n = node.iterator().get(index);
      applyPatches(patches, n);
    case [p, n]:
      throw new thx.Error('cannot apply patch $p on $n');
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
