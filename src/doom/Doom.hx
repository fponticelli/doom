package doom;

using thx.Functions;
using thx.Strings;

import doom.Node;

#if (js && html)
import js.html.*;
import js.Browser.*;
#end

class Doom {
#if (js && html)
  public static function nodeToHtml(node : Node) return switch (node : NodeImpl) {
    case Element(name, attributes, events, children):
      var el = document.createElement(name);
      for(key in attributes.keys())
        el.setAttribute(key, attributes.get(key));
      for(child in children) {
        var n = nodeToHtml(child);
        if(null != n)
          el.appendChild(n);
      }
      el;
    case Text(text): document.createTextNode(text);
    case Comment(text): document.createComment(text);
    case Empty: null;
  }
#end

  public static function nodeToXml(node : Node) return switch (node : NodeImpl) {
    case Element(name, attributes, events, children):
      var xml = Xml.createElement(name);
      for(key in attributes.keys())
        xml.set(key, attributes.get(key));
      for(child in children) {
        var n = nodeToXml(child);
        if(null != n)
          xml.addChild(n);
      }
      xml;
    case Text(text): Xml.createCData(text);
    case Comment(text): Xml.createComment(text);
    case Empty: null;
  };

  public static function nodeToString(node : Node) return switch (node : NodeImpl) {
    case Element(name, attributes, events, children):
      var buf = '<$name${attributesToString(attributes)}';
      if(children.length == 0)
        buf += '/>';
      else {
        buf += '>';
        buf += children.map.fn(nodeToString(_)).join("");
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
