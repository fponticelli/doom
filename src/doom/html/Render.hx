package doom.html;

import js.html.Document;
import js.html.Element;
import js.html.Node;
import doom.core.AttributeValue;
import doom.html.Component;
import doom.core.VNode;
import doom.core.VNodes;
using thx.Arrays;
using thx.Set;

@:access(doom.html.Component.doom)
class Render implements doom.core.IRender<Element> {
  // namespaces
  public static var defaultNamespaces = [
    "svg" => "http://www.w3.org/2000/svg"
  ];

  public var doc(default, null) : Document;
  public var namespaces(default, null) : Map<String, String>;
  public var nodeToComponent(default, null) : Map<Node, Component<Dynamic>>;
  public var componentToNode(default, null) : Map<Component<Dynamic>, Node>;

  public function new(?doc : Document, ?namespaces : Map<String, String>) {
    if(null == doc)
      this.doc = js.Browser.document;
    else
      this.doc = doc;
    if(null == namespaces) {
      this.namespaces = new Map();
      for(key in defaultNamespaces.keys())
        this.namespaces.set(key, defaultNamespaces.get(key));
    } else
      this.namespaces = namespaces;
    nodeToComponent = new Map();
    componentToNode = new Map();
  }

  public function mount(node : VNode, parent : Element) {
    parent.innerHTML = "";
    var post = [],
        n = generate(node);
    parent.appendChild(n);
    for(f in post) f();
  }

  public function apply(node : VNode, dom : Node) {
    var post = [];
    applyToNode(node, dom, dom.parentElement, post);
    for(f in post) f();
  }

  public function generate(node : VNode) : Node {
    var post = [],
        dom = generateNode(node, post);
    for(f in post) f();
    return dom;
  }

  function applyToNode(node : Null<VNode>, dom : Null<Node>, parent : Element, post : Array<Void -> Void>) {
    if(null == node && null == dom)
      return;
    if(null == node) {
      parent.removeChild(dom);
      return;
    } else if(null == dom) {
      var el = generateNode(node, post);
      parent.appendChild(el);
      return;
    }
    switch node {
      case Element(name, attributes, children):
        applyElementToNode(name, attributes, children, dom, parent, post);
      case Comment(comment):
        applyCommentToNode(comment, dom, parent, post);
      case Raw(code):
        // dots.Html.parse(code);
      case Text(text):
        applyTextToNode(text, dom, parent, post);
      case ComponentNode(comp):
        // comp.doom = this;
        // comp.willMount();
        // post.insert(0, comp.didMount);
        // var node = comp.render(),
        //     dom  = generateNode(node, post);
        // nodeToComponent.set(dom, cast comp); // TODO remove cast
        // componentToNode.set(cast comp, dom); // TODO remove cast
        // dom;
      };
  }

  function applyNodeToNode(srcDom : Null<Node>, dstDom : Null<Node>, parent : Element) {
    if(null == srcDom && null == dstDom)
      return;
    else if(null == srcDom) {
      parent.removeChild(dstDom);
      return;
    } else if(null == dstDom) {
      parent.appendChild(srcDom);
      return;
    }

    if(srcDom.nodeType == dstDom.nodeType) {
      if(srcDom.nodeType == Node.ELEMENT_NODE) {
        var srcEl = (cast srcDom : Element),
            dstEl = (cast dstDom : Element);
        applyElementAttributes(srcEl, dstEl);
/*
if(newDom.nodeType != dstDom.nodeType) {
  replaceChild(parent, dstDom, newDom);
} else if(newDom.nodeType == Node.ELEMENT_NODE && (cast newDom : Element).tagName == (cast dstDom : Element).tagName) {

} else {

}
*/
      }
      // Node.ELEMENT_NODE && (cast newDom : Element).tagName == name) {
      // applyNodeAttributes(attributes, cast dom);
    }
    replaceChild(parent, dstDom, srcDom);
  }

  function applyElementToNode(name : String, attributes : Map<String, AttributeValue>, children : VNodes, dom : Node, parent : Element, post : Array<Void -> Void>) {
    if(dom.nodeType == Node.ELEMENT_NODE && (cast dom : Element).tagName == name) {
      applyNodeAttributes(attributes, cast dom);
    } else {
      var el = createElement(name, attributes, children, post);
      applyNodeAttributes(attributes, el);
      replaceChild(parent, dom, el);
    }
  }

  function applyCommentToNode(comment : String, dom : Node, parent : Element, post : Array<Void -> Void>) {
    if(dom.nodeType == Node.COMMENT_NODE) {
      dom.textContent = comment;
    } else {
      var el = doc.createComment(comment);
      replaceChild(parent, dom, el);
    }
  }

  function applyTextToNode(text : String, dom : Node, parent : Element, post : Array<Void -> Void>) {
    if(dom.nodeType == Node.COMMENT_NODE) {
      dom.textContent = text;
    } else {
      var el = doc.createTextNode(text);
      replaceChild(parent, dom, el);
    }
  }

  function replaceChild(parent : Element, oldDom : Node, newDom : Node) {
    var comp = nodeToComponent.get(oldDom);
    if(null != comp) {
      comp.willUnmount();
      nodeToComponent.remove(oldDom);
      componentToNode.remove(comp);
    }
    parent.replaceChild(newDom, oldDom);
    if(null != comp) {
      comp.didUnmount();
    }
  }

  public function applyElementAttributes(srcDom : Element, dstDom : Element) {
    var dstAttrs = Set.createString([for(i in 0...dstDom.attributes.length) dstDom.attributes.item(i).name]),
        srcAttrs = Set.createString([for(i in 0...srcDom.attributes.length) srcDom.attributes.item(i).name]),
        removed  = dstAttrs.difference(srcAttrs);
    for(key in removed) // TODO remove event
      dstDom.removeAttribute(key);

    for(key in srcAttrs) {
      var srcValue = srcDom.getAttribute(key),
          dstValue = dstDom.getAttribute(key);
      if(srcValue == dstValue) continue;
      dstDom.setAttribute(key, srcValue);
    }
  }

  public function applyNodeAttributes(attributes : Map<String, AttributeValue>, dom : Element) {
    var domAttrs  = Set.createString([for(i in 0...dom.attributes.length) dom.attributes.item(i).name]),
        vdomAttrs = Set.createString([for(key in attributes.keys()) key]),
        removed   = domAttrs.difference(vdomAttrs);
    for(key in removed) // TODO remove event
      dom.removeAttribute(key);

    for(key in vdomAttrs) {
      switch attributes.get(key) {
        case null:
          dom.removeAttribute(key);
        case StringAttribute(s) if(null == s || s == ""):
          dom.removeAttribute(key);
        case StringAttribute(s):
          dom.setAttribute(key, s);
        case BoolAttribute(b) if(b):
          dom.setAttribute(key, "");
        case EventAttribute(e):
          setEvent(dom, key, e);
        case _:
          // do nothing
      }
    }
  }

  @:access(doom.core.Component.element)
  function generateNode(node : VNode, post : Array<Void -> Void>) : Node {
    return switch node {
      case Element(name, attributes, children):
        createElement(name, attributes, children, post);
      case Comment(comment):
        doc.createComment(comment);
      case Raw(code):
        dots.Html.parse(code);
      case Text(text):
        doc.createTextNode(text);
      case ComponentNode(comp):
        comp.willMount();
        var node = comp.render(),
            dom  = generateNode(node, post);
        comp.element = cast dom; // TODO remove cast
        post.insert(0, function() comp.didMount()); // TODO remove cast
        nodeToComponent.set(dom, cast comp); // TODO remove cast
        componentToNode.set(cast comp, dom); // TODO remove cast
        dom;
    };
  }


  public function createElement(name : String, attributes : Map<String, AttributeValue>, children : VNodes, post : Array<Void -> Void>) : Element {
    var colonPos = name.indexOf(":");
    var el = if(colonPos > 0) {
            var prefix = name.substring(0, colonPos),
                name = name.substring(colonPos + 1),
                ns = namespaces.get(prefix);
            if(null == ns)
              throw new thx.Error('element prefix "$prefix" is not associated to any namespace. Add the right namespace to Doom.namespaces.');
            doc.createElementNS(ns, name);
          } else {
            doc.createElement(name);
          }
    applyNodeAttributes(attributes, el);
    for(child in children) {
      var n = generateNode(child, post);
      el.appendChild(n);
    }
    return el;
  }

  static function setEvent(el : js.html.Element, name : String, handler : EventHandler) {
    Reflect.setField(el, 'on$name', handler);
  }

  static function removeEvent(el : js.html.Element, name : String) {
    Reflect.deleteField(el, 'on$name');
  }
}
