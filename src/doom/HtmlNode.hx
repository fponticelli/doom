package doom;

import js.html.*;
import js.html.Node as DomNode;
import js.Browser.*;
import doom.Node;
using doom.Patch;
import thx.Set;
import dots.Html;
using thx.Strings;
import doom.AttributeValue;
import thx.Timer;

class HtmlNode {
  public static function toHtml(node : Node, post : Array<Void -> Void>) : js.html.Node return switch (node : NodeImpl) {
    case Element(name, attributes, children):
      createElement(name, attributes, children, post);
    case Raw(text):
      Html.parse(text);
    case Text(text):
      document.createTextNode(text);
    case ComponentNode(comp):
      comp.node = comp.render();
      comp.init(post);
      comp.element;
  }

  static function createElement(name : String, attributes : Map<String, AttributeValue>, children : Array<Node>, post : Array<Void -> Void>) : Element {
    var colonPos = name.indexOf(":");
    var el = if(colonPos > 0) {
            var prefix = name.substring(0, colonPos),
                name = name.substring(colonPos + 1),
                ns = Doom.namespaces.get(prefix);
            if(null == ns)
              throw new thx.Error('element prefix "$prefix" is not associated to any namespace. Add the right namespace to Doom.namespaces.');
            document.createElementNS(ns, name);
          } else {
            document.createElement(name);
          }
    for(key in attributes.keys()) {
      var value = attributes.get(key);
      switch value {
        case null:
          // do nothing
        case StringAttribute(s) if(null == s || s == ""):
          // do nothing
        case StringAttribute(s):
          el.setAttribute(key, s);
        case BoolAttribute(b) if(b):
          el.setAttribute(key, "");
        case EventAttribute(e):
          addEvent(el, key, e);
        case _:
          // do nothing
      }
    }
    for(child in children) {
      var n = toHtml(child, post);
      if(null != n)
        el.appendChild(n);
    }
    return el;
  }

  static function replaceNode(enter : DomNode, exit : DomNode, patch : Patch) {
    var parent = exit.parentNode;
    if(null == parent) {
      return;
    }
    parent.replaceChild(enter, exit);
  }

  public static function applyPatches(patches : Array<Patch>, node : DomNode) {
    var post = [];
    for(patch in patches)
      applyPatch(patch, node, post);
    for(f in post) f();
  }

  static function addEvent(el : js.html.Element, name : String, handler : EventHandler) {
    Reflect.setField(el, 'on$name', handler);
  }

  static function removeEvent(el : js.html.Element, name : String) {
    Reflect.deleteField(el, 'on$name');
  }

  public static function applyPatch(patch : Patch, node : DomNode, post : Array<Void -> Void>) switch [patch, node.nodeType] {
    case [DestroyComponent(comp), _]:
      comp.didUnmount();
      comp.isUnmounted = true;
    case [MigrateComponentToComponent(oldComp, newComp), _] if(thx.Types.sameType(oldComp, newComp)):
      // TODO should check that elements are of the same type (tagName)?
      newComp.element = oldComp.element;
      newComp.node = newComp.render();
      var migrate = Reflect.field(newComp, "migrate");
      if(null != migrate)
        Reflect.callMethod(newComp, migrate, [oldComp]);
      newComp.didRefresh();
    case [MigrateComponentToComponent(oldComp, newComp), _]:
      oldComp.didUnmount();
      oldComp.isUnmounted = true;
      // newComp.node = newComp.render();
      applyPatch(MigrateElementToComponent(newComp), node, post);
    case [MigrateElementToComponent(comp), _]:
      // TODO should check that elements are of the same type (tagName)?
      comp.element = cast node;
      comp.node = comp.render();

      post.insert(0, comp.didMount);
    case [AddText(text), DomNode.ELEMENT_NODE]:
      node.appendChild(document.createTextNode(text));
    case [AddRaw(text), DomNode.ELEMENT_NODE]:
      node.appendChild(Html.parse(text));
    case [AddElement(name, attributes, children), DomNode.ELEMENT_NODE]:
      var el = createElement(name, attributes, children, post);
      node.appendChild(el);
    case [AddComponent(comp), DomNode.ELEMENT_NODE]:
      comp.node = comp.render();
      comp.init(post);
      node.appendChild(comp.element);
    case [Remove, _]:
      node.parentNode.removeChild(node);
    case [RemoveAttribute(name), DomNode.ELEMENT_NODE]:
      (cast node : js.html.Element).removeAttribute(name);
    case [SetAttribute(name, value), DomNode.ELEMENT_NODE]:
      switch value {
        case null:
          (cast node : js.html.Element).removeAttribute(name);
        case StringAttribute(s) if(s == null || s == ""):
          (cast node : js.html.Element).removeAttribute(name);
        case StringAttribute(s):
          (cast node : js.html.Element).setAttribute(name, s);
        case BoolAttribute(b) if(b):
          (cast node : js.html.Element).setAttribute(name, name);
        case BoolAttribute(_):
          (cast node : js.html.Element).removeAttribute(name);
        case EventAttribute(e):
          addEvent(cast node, name, e);
      }
    case [ReplaceWithElement(name, attributes, children), _]:
      var post = [],
          el = createElement(name, attributes, children, post);
      replaceNode(el, node, patch);
      for(f in post) f();
    case [ReplaceWithComponent(comp), _]:
      var post = [];
      comp.node = comp.render();
      comp.init(post);
      replaceNode(comp.element, node, patch);
      for(f in post) f();
    case [ReplaceWithText(text), _]:
      replaceNode(document.createTextNode(text), node, patch);
    case [ReplaceWithRaw(raw), _]:
      replaceNode(dots.Html.parse(raw), node, patch);
    case [ContentChanged(newcontent), DomNode.TEXT_NODE]
       | [ContentChanged(newcontent), DomNode.COMMENT_NODE]:
      if (node.parentNode.nodeName == "TEXTAREA") (cast node.parentNode : TextAreaElement).value = newcontent;
      else node.nodeValue = newcontent;
    case [PatchChild(index, patches), DomNode.ELEMENT_NODE]:
      var n = (cast node : js.html.Element).childNodes.item(index);
      if(null != n) { // TODO ????
        applyPatches(patches, n);
      }
    case [p, _]:
      throw new thx.Error('cannot apply patch $p on ${node}');
  };
}
