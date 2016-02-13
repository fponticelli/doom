package doom.html;

import js.html.Document;
import js.html.Element;
import js.html.Node;
import doom.core.AttributeValue;
import doom.core.VNode;
using thx.Arrays;
using thx.Set;

class Render implements doom.core.IRender<Element> {
  // namespaces
  public static var defaultNamespaces = [
    "svg" => "http://www.w3.org/2000/svg"
  ];

  public var doc(default, null) : Document;
  public var namespaces(default, null) : Map<String, String>;
  public var nodeToComponent(default, null) : Map<Node, Component<Dynamic, Dynamic>>;
  public var componentToNode(default, null) : Map<Component<Dynamic, Dynamic>, Node>;

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

  public function render(node : VNode, parent : Element) {

  }

  public function apply(node : VNode, dom : Element) {

  }

  public function generate(node : VNode) : Node {
    var post = [],
        dom = generateNode(node, post);
    for(f in post) f();
    return dom;
  }

  function applyToNode(node : VNode, dom : Node, parent : Element, post : Array<Void -> Void>) {
    switch node {
      case Element(name, attributes, children):
        applyElementToNode(name, attributes, children, dom, parent, post);
      case Comment(comment):
        // doc.createComment(comment);
      case Raw(code):
        // dots.Html.parse(code);
      case Text(text):
        // doc.createTextNode(text);
      case ComponentNode(comp):
        // comp.willMount();
        // post.insert(0, comp.didMount);
        // var node = comp.render(),
        //     dom  = generateNode(node, post);
        // nodeToComponent.set(dom, cast comp); // TODO remove cast
        // componentToNode.set(cast comp, dom); // TODO remove cast
        // dom;
    };
  }

  function applyElementToNode(name : String, attributes : Map<String, AttributeValue>, children : Array<VNode>, dom : Node, parent : Element, post : Array<Void -> Void>) {
    if(dom.nodeType == Node.ELEMENT_NODE && (cast dom : Element).tagName == name) {
      updateAttributes(attributes, cast dom);
    } else {
      var el = createElement(name, attributes, children, post);
      updateAttributes(attributes, el);
      parent.replaceChild(el, dom);
    }
  }

  public function updateAttributes(attributes : Map<String, AttributeValue>, dom : Element) {
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
        post.insert(0, comp.didMount);
        var node = comp.render(),
            dom  = generateNode(node, post);
        nodeToComponent.set(dom, cast comp); // TODO remove cast
        componentToNode.set(cast comp, dom); // TODO remove cast
        dom;
    };
  }


  public function createElement(name : String, attributes : Map<String, AttributeValue>, children : Array<VNode>, post : Array<Void -> Void>) : Element {
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
    updateAttributes(attributes, el);
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
