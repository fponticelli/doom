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
    applyToNode(node, dom, dom.parentElement, post, false);
    for(f in post) f();
  }

  public function generate(node : VNode) : Node {
    trace("** generate");
    var post = [],
        dom = generateNode(node, post);
    for(f in post) f();
    return dom;
  }

  function applyToNode(node : Null<VNode>, dom : Null<Node>, parent : Element, post : Array<Void -> Void>, tryUnmount : Bool) : Node {
    trace("** applyToNode, has node? " + (null != node) + ", has dom? " + (null != dom) + ", tryUnmount? " + tryUnmount);
    if(null == node && null == dom) {
      return null;
    } else if(null == node) {
      // TODO remove component
      trace("REMOVE CHILD");
      if(tryUnmount)
        unmountDomComponent(dom);
      parent.removeChild(dom);
      return null;
    } else if(null == dom) {
      var el = generateNode(node, post);
      parent.appendChild(el);
      return el;
    }
    return switch node {
      case Element(name, attributes, children):
        if(tryUnmount)
          unmountDomComponent(dom);
        applyElementToNode(name, attributes, children, dom, parent, post);
      case Comment(comment):
        if(tryUnmount)
          unmountDomComponent(dom);
        applyCommentToNode(comment, dom, parent, post);
      case Raw(code):
        if(tryUnmount)
          unmountDomComponent(dom);
        var node = dots.Html.parse(code);
        applyNodeToNode(node, dom, parent, true);
      case Text(text):
        if(tryUnmount)
          unmountDomComponent(dom);
        applyTextToNode(text, dom, parent, post);
      case ComponentNode(comp):
        applyComponentToNode(cast comp, dom, parent, post); // TODO remove cast
      };
  }

  function applyNodeToNode(srcDom : Null<Node>, dstDom : Null<Node>, parent : Element, tryUnmount : Bool) : Node {
    trace("** applyNodeToNode");
    if(null == srcDom && null == dstDom)
      return null;
    else if(null == srcDom) {
      parent.removeChild(dstDom);
      return null;
    } else if(null == dstDom) {
      parent.appendChild(srcDom);
      return srcDom;
    }
    if(tryUnmount)
      unmountDomComponent(dstDom);
    if(srcDom.nodeType == dstDom.nodeType) {
      if(srcDom.nodeType == Node.ELEMENT_NODE) {
        var srcEl = (cast srcDom : Element),
            dstEl = (cast dstDom : Element);
        if(srcEl.tagName == dstEl.tagName) {
          applyElementAttributes(srcEl, dstEl);
          zipNodeListAndNodeList(srcEl.childNodes, dstEl.childNodes).each(function(t) {
            applyNodeToNode(t._0, t._1, dstEl, true);
          });
          return dstDom;
        } else {
          return replaceChild(parent, dstDom, srcDom);
        }
      } else if(srcDom.nodeType == Node.COMMENT_NODE || srcDom.nodeType == Node.TEXT_NODE) {
        dstDom.textContent = srcDom.textContent;
        return dstDom;
      } else {
        return replaceChild(parent, dstDom, srcDom);
      }
    } else {
      return replaceChild(parent, dstDom, srcDom);
    }
  }

  function migrate<Props>(src : doom.html.Component<Props>, dst : doom.html.Component<Props>) {
    dst.props = src.props;
    src.update = dst.update;
  }

  function applyComponentToNode<Props>(newComp : doom.html.Component<Props>, dom : Node, parent : Element, post : Array<Void -> Void>) : Node {
    var oldComp = nodeToComponent.get(dom);
    trace("** applyComponentToNode, has oldComp? " + (null != oldComp) + ", are same type? " + Types.sameType(newComp, oldComp));
    if(null != oldComp) {
      if(Types.sameType(newComp, oldComp)) {
        migrate(cast newComp, cast oldComp);
        var node = oldComp.render();
        return applyToNode(node, dom, parent, post, false);
      } else {
        oldComp.willUnmount();
        nodeToComponent.set(dom, cast newComp); // TODO remove cast
        componentToNode.remove(oldComp); // TODO remove cast
        componentToNode.set(cast newComp, dom); // TODO remove cast

        newComp.willMount();
        var node = newComp.render();
        newComp.apply = cast this.apply; // TODO remove cast
        var dom = applyToNode(node, dom, parent, post, false);
        newComp.element = cast dom; // TODO remove cast

        post.insert(0, function() newComp.didMount()); // TODO remove cast
        nodeToComponent.set(dom, cast newComp); // TODO remove cast
        componentToNode.set(cast newComp, dom); // TODO remove cast

        oldComp.isUnmounted = true;
        oldComp.element = null;
        oldComp.didUnmount();
        return dom;
      }
    } else {
      newComp.willMount();
      var node = newComp.render();
      newComp.apply = cast this.apply; // TODO remove cast
      var dom = applyToNode(node, dom, parent, post, false);
      newComp.element = cast dom; // TODO remove cast
      post.insert(0, function() newComp.didMount()); // TODO remove cast
      nodeToComponent.set(dom, cast newComp); // TODO remove cast
      componentToNode.set(cast newComp, dom); // TODO remove cast
      return dom;
    }
  }

  function unmountDomComponent(dom : Node) {
    var comp = nodeToComponent.get(dom);
    if(null == comp) return;
    unmountComponent(comp);
  }

  function unmountComponent<Props>(comp : Component<Props>) {
    var node = componentToNode.get(comp);
    componentToNode.remove(comp);
    nodeToComponent.remove(node);
    comp.willUnmount();
    comp.isUnmounted = true;
    comp.element = null;
    comp.didUnmount();
  }

  function applyElementToNode(name : String, attributes : Map<String, AttributeValue>, children : VNodes, dom : Node, parent : Element, post : Array<Void -> Void>) : Node {
    trace("** applyElementToNode, name: " + name.toUpperCase() + ", old node: " + (dom.nodeType == Node.ELEMENT_NODE ? (cast dom : Element).tagName : '${dom.nodeType}'));
    if(dom.nodeType == Node.ELEMENT_NODE && (cast dom : Element).tagName == name.toUpperCase()) {
      applyNodeAttributes(attributes, cast dom);
      zipVNodesAndNodeList(children, dom.childNodes).each(function(t) {
        applyToNode(t._0, t._1, cast dom, post, true);
      });
      return dom;
    } else {
      var el = createElement(name, attributes, children, post);
      // applyNodeAttributes(attributes, el);
      return replaceChild(parent, dom, el);
    }
  }

  function applyCommentToNode(comment : String, dom : Node, parent : Element, post : Array<Void -> Void>) : Node {
    trace("** applyCommentToNode");
    if(dom.nodeType == Node.COMMENT_NODE) {
      dom.textContent = comment;
      return dom;
    } else {
      var el = doc.createComment(comment);
      return replaceChild(parent, dom, el);
    }
  }

  function applyTextToNode(text : String, dom : Node, parent : Element, post : Array<Void -> Void>) : Node {
    trace("** applyTextToNode");
    if(dom.nodeType == Node.TEXT_NODE) {
      dom.textContent = text;
      return dom;
    } else {
      var el = doc.createTextNode(text);
      return replaceChild(parent, dom, el);
    }
  }

  function replaceChild(parent : Element, oldDom : Node, newDom : Node) {
    trace("** replaceChild, is same? " + (oldDom == newDom));
    if(oldDom == newDom)
      return newDom;
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
    // parent.insertBefore(newDom, oldDom);
    // parent.removeChild(oldDom);

    // if(null != oldComp && !Types.sameType(oldComp, newComp)) {
    //   oldComp.didUnmount();
    // }
    return newDom;
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
