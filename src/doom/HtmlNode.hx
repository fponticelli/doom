#if (js && html)
package doom;

import js.html.*;
import js.html.Node as N;
import js.Browser.*;
import doom.Node;
import thx.Set;

class HtmlNode {
  static var customEvents = Set.createString(["create", "mount"]);

  public static function toHtml(node : Node) : js.html.Node return switch (node : NodeImpl) {
    case Element(name, attributes, events, children):
      createElement(name, attributes, events, children);
    case Raw(text):
      createElementFromHtml(text);
    case Text(text): document.createTextNode(text);
    case Comment(text): document.createComment(text);
    case Empty: null;
  }

  static function createElement(name : String, attributes : Map<String, String>, events : Map<String, EventHandler>, children : Array<Node>) {
    var el = document.createElement(name);
    for(key in attributes.keys())
      el.setAttribute(key, attributes.get(key));
    for(child in children) {
      var n = toHtml(child);
      if(null != n)
        el.appendChild(n);
    }
    for(key in events.keys())
      addEvent(el, key, events.get(key));
    trigger(el, "create");
    return el;
  }

  public static function applyPatches(patches : Array<Patch>, node : N)
    for(patch in patches)
      applyPatch(patch, node);

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

  public static function applyPatch(patch : Patch, node : N) switch [patch, node.nodeType] {
    case [AddText(text), N.ELEMENT_NODE]:
      node.appendChild(document.createTextNode(text));
    case [AddComment(text), N.ELEMENT_NODE]:
      node.appendChild(document.createComment(text));
    case [AddElement(name, attributes, events, children), N.ELEMENT_NODE]:
      var el = createElement(name, attributes, events, children);
      node.appendChild(el);
      trigger(el, "mount");
    case [Remove, _]:
      node.parentNode.removeChild(node);
    case [RemoveAttribute(name), N.ELEMENT_NODE]:
      (cast node : js.html.Element).removeAttribute(name);
    case [SetAttribute(name, value), N.ELEMENT_NODE]:
      (cast node : js.html.Element).setAttribute(name, value);
    case [RemoveEvent(name), N.ELEMENT_NODE]:
      removeEvent(cast node, name);
    case [SetEvent(name, handler), N.ELEMENT_NODE]:
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
      parent.replaceChild(document.createComment(text), node);
    case [ContentChanged(newcontent), N.TEXT_NODE]
       | [ContentChanged(newcontent), N.COMMENT_NODE]:
      node.nodeValue = newcontent;
    case [PatchChild(index, patches), N.ELEMENT_NODE]:
      var n = (cast node : js.html.Element).childNodes.item(index);
      applyPatches(patches, n);
    case [p, n]:
      throw new thx.Error('cannot apply patch $p on $n');
  };
}
#end
