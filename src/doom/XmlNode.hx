package doom;

using thx.Functions;
using thx.Strings;
using thx.Iterators;
import doom.Node;
import doom.AttributeValue;

class XmlNode {
  public static function toXml(node : Node) return switch (node : NodeImpl) {
    case Element(name, attributes, children):
      createElement(name, attributes, children);
    case Text(text): Xml.createPCData(text);
    case Raw(text): Xml.parse(text);
    case Comment(text): Xml.createComment(text);
    case ComponentNode(comp): toXml(comp.node);
  };

  static function createElement(name : String, attributes : Map<String, AttributeValue>, children : Array<Node>) {
    var xml = Xml.createElement(name);
    for(key in attributes.keys()) {
      var v = attributes.get(key);
      switch v {
        case StringAttribute(s): xml.set(key, s);
        case BoolAttribute(b) if(b): xml.set(key, key);
        case _: // do nothing for events
      }
    }

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
    case [AddText(text), Element]:
      node.addChild(Xml.createPCData(text));
    case [AddRaw(text), Element]:
      node.addChild(Xml.parse(text));
    case [AddComment(text), Element]:
      node.addChild(Xml.createComment(text));
    case [AddElement(name, attributes, children), Element]:
      node.addChild(createElement(name, attributes, children));
    case [Remove, _]:
      node.parent.removeChild(node);
    case [RemoveAttribute(name), Element]:
      node.remove(name);
    case [SetAttribute(name, value), Element]:
      switch value {
        case StringAttribute(s) if(s.hasContent()):
          node.set(name, s);
        case BoolAttribute(b) if(b):
          node.set(name, name);
        case StringAttribute(_), BoolAttribute(_):
          node.remove(name);
        case _:
      }
    case [ReplaceWithElement(name, attributes, children), _]:
      var parent = node.parent,
          pos = parent.iterator().indexOf(node);
      parent.removeChild(node);
      parent.insertChild(createElement(name, attributes, children), pos);
    case [ReplaceWithText(text), _]:
      var parent = node.parent,
          pos = parent.iterator().indexOf(node);
      parent.removeChild(node);
      parent.insertChild(Xml.createPCData(text), pos);
    case [ReplaceWithRaw(raw), _]:
      var parent = node.parent,
          pos = parent.iterator().indexOf(node);
      parent.removeChild(node);
      parent.insertChild(Xml.parse(raw), pos);
    case [ReplaceWithComment(text), _]:
      var parent = node.parent,
          pos = parent.iterator().indexOf(node);
      parent.removeChild(node);
      parent.insertChild(Xml.createComment(text), pos);
    case [ContentChanged(newcontent), CData]
       | [ContentChanged(newcontent), Comment]:
      node.nodeValue = newcontent;
    case [PatchChild(index, patches), Element]:
      var n = node.iterator().get(index);
      applyPatches(patches, n);
    case [p, n]:
      throw new thx.Error('cannot apply patch $p on $n');
  };

  public static function toString(node : Node) return switch (node : NodeImpl) {
    case Element(name, attributes, children):
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
    case Raw(text): text;
    case Comment(text): '<!--$text-->';
    case ComponentNode(comp): toString(comp.node);
  };

  public static function attributesToString(attributes : Map<String, AttributeValue>) {
    var buf = "";
    for(key in attributes.keys()) {
      var value = attributes.get(key);
      switch value {
        case StringAttribute(s) if(s.hasContent()):
          buf += ' $key="${s.replace('"', '&quot;')}"';
        case BoolAttribute(b) if(b):
          buf += ' $key="$key"';
        case _:
      }
    }
    return buf;
  }
}
