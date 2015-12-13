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
  public static function toHtml(node : Node) : js.html.Node return switch (node : NodeImpl) {
    case Element(name, attributes, children):
      createElement(name, attributes, children);
    case Raw(text):
      Html.parse(text);
    case Text(text): document.createTextNode(text);
    // case Comment(text):
    //   createComment(text);
    case ComponentNode(comp):
      comp.init();
      thx.Timer.immediate(comp.mount);
      comp.element;
  }

  static function createElement(name : String, attributes : Map<String, AttributeValue>, children : Array<Node>) : Element {
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
        case StringAttribute(s) if(s.hasContent()):
          el.setAttribute(key, s);
        case BoolAttribute(b) if(b):
          el.setAttribute(key, "");
        case EventAttribute(e):
          addEvent(el, key, e);
        case _:
      }
    }
    for(child in children) {
      var n = toHtml(child);
      if(null != n)
        el.appendChild(n);
    }
    return el;
  }

  public static function createComment(comment : String)
    return document.createComment(comment);

  public static function applyPatches(patches : Array<Patch>, node : DomNode) {
    for(patch in patches)
      applyPatch(patch, node);
  }

  static function addEvent(el : js.html.Element, name : String, handler : EventHandler) {
    Reflect.setField(el, 'on$name', handler);
  }

  static function removeEvent(el : js.html.Element, name : String) {
    Reflect.deleteField(el, 'on$name');
  }

  public static function applyPatch(patch : Patch, node : DomNode) switch [patch, node.nodeType] {
    case [MigrateElementToComponent(comp), _]:
      // trace("MIGRATE NODE?", null != comp.element, comp.toString(), node);
      // if(null == comp.element)
      comp.element = cast node;
      thx.Timer.immediate(comp.mount);
    case [AddText(text), DomNode.ELEMENT_NODE]:
      node.appendChild(document.createTextNode(text));
    case [AddRaw(text), DomNode.ELEMENT_NODE]:
      node.appendChild(Html.parse(text));
    // case [AddComment(text), DomNode.ELEMENT_NODE]:
    //   node.appendChild(createComment(text));
    case [AddElement(name, attributes, children), DomNode.ELEMENT_NODE]:
      var el = createElement(name, attributes, children);
      node.appendChild(el);
    case [AddComponent(comp), DomNode.ELEMENT_NODE]:
      comp.init();
      node.appendChild(comp.element);
    case [Remove, _]:
      node.parentNode.removeChild(node);
    case [RemoveAttribute(name), DomNode.ELEMENT_NODE]:
      (cast node : js.html.Element).removeAttribute(name);
    case [SetAttribute(name, value), DomNode.ELEMENT_NODE]:
      switch value {
        case StringAttribute(s) if(s.hasContent()):
          (cast node : js.html.Element).setAttribute(name, s);
        case BoolAttribute(b) if(b):
          (cast node : js.html.Element).setAttribute(name, name);
        case StringAttribute(_), BoolAttribute(_):
          (cast node : js.html.Element).removeAttribute(name);
        case EventAttribute(e):
          addEvent(cast node, name, e);
      }
    case [ReplaceWithElement(name, attributes, children), _]:
      var parent = node.parentNode,
          el = createElement(name, attributes, children);
      parent.replaceChild(el, node);
    case [ReplaceWithComponent(comp), _]:
      var parent = node.parentNode;
      comp.init();
      thx.Timer.immediate(comp.mount);
      parent.replaceChild(comp.element, node);
    case [ReplaceWithText(text), _]:
      var parent = node.parentNode;
      parent.replaceChild(document.createTextNode(text), node);
    case [ReplaceWithRaw(raw), _]:
      var parent = node.parentNode;
      parent.replaceChild(dots.Html.parse(raw), node);
    // case [ReplaceWithComment(text), _]:
    //   var parent = node.parentNode;
    //   parent.replaceChild(createComment(text), node);
    case [ContentChanged(newcontent), DomNode.TEXT_NODE]
       | [ContentChanged(newcontent), DomNode.COMMENT_NODE]:
      if (node.parentNode.nodeName == "TEXTAREA") (cast node.parentNode : TextAreaElement).value = newcontent;
      else node.nodeValue = newcontent;
    case [PatchChild(index, patches), DomNode.ELEMENT_NODE]:
      var n = (cast node : js.html.Element).childNodes.item(index);
      if(null != n) // TODO ????
        applyPatches(patches, n);
    case [p, _]:
      throw new thx.Error('cannot apply patch $p on ${node}');
  };
}
