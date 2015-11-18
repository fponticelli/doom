#if (js && html)
package doom;

import js.html.*;
import js.html.Node as DomNode;
import js.Browser.*;
import doom.Node;
using doom.Patch;
import thx.Set;
import dots.Html;
using thx.Strings;

class HtmlNode {
  static var customEvents = Set.createString(["create", "mount"]);

  public static function toHtml(node : Node) : js.html.Node return switch (node : NodeImpl) {
    case Element(name, attributes, events, children):
      createElement(name, attributes, events, children);
    case Raw(text):
      Html.parse(text);
    case Text(text): document.createTextNode(text);
    case Comment(text): document.createComment(text);
    case ComponentNode(comp):
      comp.init();
      return comp.element;
    case Empty: null;
  }

  static function createElement(name : String, attributes : Map<String, String>, events : Map<String, EventHandler>, children : Array<Node>) {
    var el = document.createElement(name);
    for(key in attributes.keys()) {
      var value = attributes.get(key);
      if(null == value)
        continue;
      el.setAttribute(key, value);
    }
    for(key in events.keys())
      addEvent(el, key, events.get(key));
    trigger(el, "create");
    for(child in children) {
      var n = toHtml(child);
      if(null != n)
        el.appendChild(n);
    }
    return el;
  }

  public static function applyPatches(patches : Array<Patch>, node : DomNode) {
    for(patch in patches)
      applyPatch(patch, node);
  }

  static function trigger(el : Element, name : String) {
    var event = new js.html.CustomEvent(name);
    el.dispatchEvent(event);
  }

  static function addEvent(el : js.html.Element, name : String, handler : EventHandler) {
    Reflect.setField(el, 'on$name', handler);
    if(customEvents.exists(name))
      el.addEventListener(name, handler, false);
  }

  static function removeEvent(el : js.html.Element, name : String) {
    if(customEvents.exists(name))
      el.removeEventListener(name, Reflect.field(el, 'on$name'), false);
    Reflect.deleteField(el, 'on$name');
  }

  public static function applyPatch(patch : Patch, node : DomNode) switch [patch, node.nodeType] {
    case [AddText(text), DomNode.ELEMENT_NODE]:
      node.appendChild(document.createTextNode(text));
    case [AddRaw(text), DomNode.ELEMENT_NODE]:
      node.appendChild(Html.parse(text));
    case [AddComment(text), DomNode.ELEMENT_NODE]:
      node.appendChild(document.createComment(text));
    case [AddElement(name, attributes, events, children), DomNode.ELEMENT_NODE]:
      var el = createElement(name, attributes, events, children);
      node.appendChild(el);
      trigger(el, "mount");
    case [Remove, _]:
      node.parentNode.removeChild(node);
    case [RemoveAttribute(name), DomNode.ELEMENT_NODE]:
      (cast node : js.html.Element).removeAttribute(name);
    case [SetAttribute(name, value), DomNode.ELEMENT_NODE] if(value.isEmpty()):
      (cast node : js.html.Element).removeAttribute(name);
    case [SetAttribute(name, value), DomNode.ELEMENT_NODE]:
      (cast node : js.html.Element).setAttribute(name, value);
    case [RemoveEvent(name), DomNode.ELEMENT_NODE]:
      removeEvent(cast node, name);
    case [SetEvent(name, handler), DomNode.ELEMENT_NODE]:
      addEvent(cast node, name, handler);
    case [ReplaceWithElement(name, attributes, events, children), _]:
      var parent = node.parentNode,
          el = createElement(name, attributes, events, children);
      parent.replaceChild(el, node);
      trigger(el, "mount");
    case [ReplaceWithText(text), _]:
      var parent = node.parentNode;
      parent.replaceChild(document.createTextNode(text), node);
    case [ReplaceWithRaw(text), _]:
      var parent = node.parentNode;
      parent.replaceChild(document.createTextNode(text), node);
    case [ReplaceWithComment(text), _]:
      var parent = node.parentNode;
      parent.replaceChild(Html.parse(text), node);
    case [ContentChanged(newcontent), DomNode.TEXT_NODE]
       | [ContentChanged(newcontent), DomNode.COMMENT_NODE]:
      node.nodeValue = newcontent;
    case [PatchChild(index, patches), DomNode.ELEMENT_NODE]:
      var n = (cast node : js.html.Element).childNodes.item(index);
      applyPatches(patches, n);
    case [p, n]:
      throw new thx.Error('cannot apply patch $p on $n');
  };
}
#end
