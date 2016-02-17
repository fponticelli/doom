package doom.html;

import js.html.Document;
import js.html.Element;
import js.html.Node;
import doom.core.AttributeValue;
import doom.html.Component;
import doom.core.VNode;
import doom.core.VNodes;
import thx.Types;
using thx.Arrays;
using thx.Set;
using thx.Tuple;

@:access(doom.core.Component)
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
    trace("** apply");
    // trace(node);
    // trace('has dom? ${null != dom}');
    applyToNode(node, dom, dom.parentElement, post);
    for(f in post) f();
  }

  public function generate(node : VNode) : Node {
    trace("** generate");
    var post = [],
        dom = generateNode(node, post);
    for(f in post) f();
    return dom;
  }

  function applyToNode(node : Null<VNode>, dom : Null<Node>, parent : Element, post : Array<Void -> Void>) {
    trace("** applyToNode, has node? " + (null != node) + ", has dom? " + (null != dom));
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
        applyComponentToNode(cast comp, dom, parent, post); // TODO remove cast
      };
  }

  function applyNodeToNode(srcDom : Null<Node>, dstDom : Null<Node>, parent : Element) {
    trace("** applyNodeToNode");
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
      // TODO, should we check if there is a component associated?
      if(srcDom.nodeType == Node.ELEMENT_NODE) {
        var srcEl = (cast srcDom : Element),
            dstEl = (cast dstDom : Element);
        applyElementAttributes(srcEl, dstEl);
        zipNodeListAndNodeList(srcEl.childNodes, dstEl.childNodes).each(function(t) {
          applyNodeToNode(t._0, t._1, dstEl);
        });
      } else {
        throw "not implemented";
      }
    } else {
      replaceChild(parent, dstDom, srcDom);
    }
  }

  function migrate<Props>(src : doom.html.Component<Props>, dst : doom.html.Component<Props>) {
    dst.props = src.props;
    src.update = dst.update;
  }

  function applyComponentToNode<Props>(newComp : doom.html.Component<Props>, dom : Node, parent : Element, post : Array<Void -> Void>) {
    var oldComp = nodeToComponent.get(dom);
    trace("** applyComponentToNode, has oldComp? " + (null != oldComp) + ", are same type? " + Types.sameType(newComp, oldComp));
    if(null != oldComp) {
      if(Types.sameType(newComp, oldComp)) {
        migrate(cast newComp, cast oldComp);
        var node = oldComp.render();
        applyToNode(node, dom, parent, post);
      } else {
        oldComp.willUnmount();
        nodeToComponent.set(dom, cast newComp); // TODO remove cast
        componentToNode.remove(oldComp); // TODO remove cast
        componentToNode.set(cast newComp, dom); // TODO remove cast
        var node = newComp.render();
        applyToNode(node, dom, parent, post);
        oldComp.isUnmounted = true;
        oldComp.didUnmount();
      }
    } else {
      var node = newComp.render();
      nodeToComponent.set(dom, cast newComp); // TODO remove cast
      componentToNode.set(cast newComp, dom); // TODO remove cast
      applyToNode(node, dom, parent, post);
    }
  }

  function applyElementToNode(name : String, attributes : Map<String, AttributeValue>, children : VNodes, dom : Node, parent : Element, post : Array<Void -> Void>) {
    trace("** applyElementToNode, name: " + name.toUpperCase() + ", old node: " + (dom.nodeType == Node.ELEMENT_NODE ? (cast dom : Element).tagName : '${dom.nodeType}'));
    if(dom.nodeType == Node.ELEMENT_NODE && (cast dom : Element).tagName == name.toUpperCase()) {
      applyNodeAttributes(attributes, cast dom);
      zipVNodesAndNodeList(children, dom.childNodes).each(function(t) {
        applyToNode(t._0, t._1, cast dom, post);
      });
    } else {
      var el = createElement(name, attributes, children, post);
      applyNodeAttributes(attributes, el);
      replaceChild(parent, dom, el);
    }
  }

  function applyCommentToNode(comment : String, dom : Node, parent : Element, post : Array<Void -> Void>) {
    trace("** applyCommentToNode");
    if(dom.nodeType == Node.COMMENT_NODE) {
      dom.textContent = comment;
    } else {
      var el = doc.createComment(comment);
      replaceChild(parent, dom, el);
    }
  }

  function applyTextToNode(text : String, dom : Node, parent : Element, post : Array<Void -> Void>) {
    trace("** applyTextToNode");
    if(dom.nodeType == Node.COMMENT_NODE) {
      dom.textContent = text;
    } else {
      var el = doc.createTextNode(text);
      replaceChild(parent, dom, el);
    }
  }

  function replaceChild(parent : Element, oldDom : Node, newDom : Node) {
    trace("** replaceChild, is same? " + (oldDom == newDom));
    if(oldDom == newDom)
      return;
    // var oldComp = nodeToComponent.get(oldDom),
    //     newComp = nodeToComponent.get(newDom);
    // if(null != oldComp) {
    //   nodeToComponent.remove(oldDom);
    //   componentToNode.remove(oldComp);
    //   if(!Types.sameType(oldComp, newComp)) {
    //     oldComp.willUnmount();
    //   }
    // }
    parent.replaceChild(newDom, oldDom);
    // if(null != oldComp && !Types.sameType(oldComp, newComp)) {
    //   oldComp.didUnmount();
    // }
  }

  function zipVNodesAndNodeList(vnodes : VNodes, children : js.html.NodeList) : Array<Tuple2<VNode, Node>> {
    var len = thx.Ints.max(vnodes.length, children.length);
    return [for(i in 0...len) Tuple2.of(vnodes[i], children[i])];
  }

  function zipNodeListAndNodeList(left : js.html.NodeList, right : js.html.NodeList) : Array<Tuple2<Node, Node>> {
    var len = thx.Ints.max(left.length, right.length);
    return [for(i in 0...len) Tuple2.of(left[i], right[i])];
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
        comp.apply = cast this.apply; // TODO remove cast
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
