package doom.html;

import js.html.Document;
import js.html.Element;
import js.html.Node as DOMNode;
import doom.core.AttributeValue;
import doom.html.Component;
import doom.html.Attributes.*;
import doom.core.VNode;
import doom.core.VNodes;
import dots.EventHandler;
import thx.Types;
using thx.Arrays;
using thx.Set;
using thx.Tuple;

@:access(doom.core.Component)
class Render implements doom.core.IRender<Element> {
  // namespaces
  public static var defaultNamespaces = [
    "svg"   => "http://www.w3.org/2000/svg",
    "xlink" => "http://www.w3.org/1999/xlink",
    "ev"    => "http://www.w3.org/2001/xml-events",
    "xsl"   => "http://www.w3.org/1999/XSL/Transform",
    "m"     => "http://www.w3.org/1998/Math/MathML"
  ];

  public var doc(default, null) : Document;
  public var namespaces(default, null) : Map<String, String>;
  public var domComponentMap(default, null) : DomComponentMap;

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
    domComponentMap = new DomComponentMap();
  }

  public function mount(node : VNode, parent : Element) {
    // trace("** mount");
    parent.innerHTML = "";
    var post = [],
        n = generateDom(node, post);
    parent.appendChild(n);
    // trace('** mount: post (${post.length})');
    for(f in post) f();
  }

  public function apply(node : VNode, dom : DOMNode) {
    var post = [];
    // trace("** apply");
    applyToNode(node, dom, dom.parentElement, post, false);
    for(f in post) f();
  }

  public function generate(node : VNode) : DOMNode {
    // trace("** generate");
    var post = [],
        dom = generateDom(node, post);
    // trace('** generate: post (${post.length})');
    for(f in post) f();
    return dom;
  }

  function applyToNode(node : Null<VNode>, dom : Null<DOMNode>, parent : Element, post : Array<Void -> Void>, tryUnmount : Bool) : DOMNode {
    // trace("** applyToNode, has node? " + (null != node) + ", has dom? " + (null != dom) + ", tryUnmount? " + tryUnmount);
    if(null == node && null == dom) {
      return null;
    } else if(null == node) {
      // trace("** applyToNode: REMOVE CHILD");
      if(tryUnmount)
        unmountDomComponent(dom);
      parent.removeChild(dom);
      return null;
    } else if(null == dom) {
      var el = generateDom(node, post);
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
      case Comp(comp):
        applyComponentToNode(cast comp, dom, parent, post); // TODO remove cast
    };
  }

  function applyNodeToNode(srcDom : Null<DOMNode>, dstDom : Null<DOMNode>, parent : Element, tryUnmount : Bool) : DOMNode {
    // trace("** applyNodeToNode");
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
      if(srcDom.nodeType == DOMNode.ELEMENT_NODE) {
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
      } else if(srcDom.nodeType == DOMNode.COMMENT_NODE || srcDom.nodeType == DOMNode.TEXT_NODE) {
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
    var fields = dst.migrationFields();
    for(field in fields) {
      var f = Reflect.field(src, field);
      if(Reflect.isFunction(f)) {
        f = Reflect.field(dst, field);
        Reflect.setField(src, field, function() {
          Reflect.callMethod(dst, f, untyped __js__("arguments"));
        });
      } else {
        Reflect.setField(dst, field, f);
      }
    }
  }

  function applyComponentToNode<Props>(newComp : doom.html.Component<Props>, dom : DOMNode, parent : Element, post : Array<Void -> Void>) : DOMNode {
    var oldComps = domComponentMap.getComponents(dom);
    // trace("** applyComponentToNode, has oldComp? " + (null != oldComp) + ", are same type? " + Types.sameType(newComp, oldComp));
    if(null != oldComps) {
      var oldComp = oldComps.find(function(comp) return Types.sameType(comp, newComp));
      if(null == oldComp) {
        for(oldComp in oldComps) {
          oldComp.willUnmount();
          domComponentMap.removeByComponent(oldComp);
          newComp.willMount();
          var node = renderComponent(newComp);
          newComp.apply = cast this.apply; // TODO remove cast
          var dom = applyToNode(node, dom, parent, post, false);
          newComp.node = cast dom; // TODO remove cast

          post.insert(0, function() newComp.didMount()); // TODO remove cast
          domComponentMap.set(newComp, dom); // TODO remove case

          oldComp.isUnmounted = true;
          oldComp.node = null;
          oldComp.didUnmount();
        }
        return dom;
      } else {
        migrate(cast newComp, cast oldComp);
        oldComp.willUpdate();
        post.push(oldComp.didUpdate);
        if(oldComp.shouldRender()) {
          domComponentMap.removeByComponent(oldComp);
          // domComponentMap.remove(oldComp, dom);
          var node = renderComponent(oldComp),
          newDom = applyToNode(node, dom, parent, post, false);
          oldComp.node = newDom;
          domComponentMap.set(oldComp, newDom);
          return newDom;
        } else {
          return dom;
        }
      }
    } else {
      newComp.willMount();
      var node = renderComponent(newComp);
      newComp.apply = cast this.apply; // TODO remove cast
      var dom = applyToNode(node, dom, parent, post, false);
      newComp.node = cast dom; // TODO remove cast
      post.insert(0, function() newComp.didMount()); // TODO remove cast
      domComponentMap.set(newComp, dom);
      return dom;
    }
  }

  function unmountDomComponent(dom : DOMNode) {
    for(i in 0...dom.childNodes.length) {
      var child = dom.childNodes[i];
      unmountDomComponent(child);
    }
    var comps = domComponentMap.getComponents(dom);
    if(null == comps) return;
    for(comp in comps)
      unmountComponent(comp);
  }

  function renderComponent<Props, El>(comp : doom.core.Component<Props, El>) : VNode {
    try {
      return comp.render();
    } catch(e : Dynamic) {
      var typeName = thx.Types.valueTypeToString(comp);
      return throw new thx.error.ErrorWrapper('unable to render $typeName', e);
    }
  }

  function unmountComponent<Props>(comp : Component<Props>) {
    domComponentMap.removeByComponent(comp);
    comp.willUnmount();
    comp.isUnmounted = true;
    comp.node = null;
    comp.didUnmount();
  }

  function applyElementToNode(name : String, attributes : Map<String, AttributeValue>, children : VNodes, dom : DOMNode, parent : Element, post : Array<Void -> Void>) : DOMNode {
    // trace("** applyElementToNode, name: " + name.toUpperCase() + ", old node: " + (dom.nodeType == DOMNode.ELEMENT_NODE ? (cast dom : Element).tagName : '${dom.nodeType}'));
    if(dom.nodeType == DOMNode.ELEMENT_NODE && (cast dom : Element).tagName == name.toUpperCase()) {
      applyNodeAttributes(attributes, cast dom);
      zipVNodesAndNodeList(children, dom.childNodes).each(function(t) {
        applyToNode(t._0, t._1, cast dom, post, true);
      });
      return dom;
    } else {
      var el = createElement(name, attributes, children, post);
      return replaceChild(parent, dom, el);
    }
  }

  function applyCommentToNode(comment : String, dom : DOMNode, parent : Element, post : Array<Void -> Void>) : DOMNode {
    // trace("** applyCommentToNode");
    if(dom.nodeType == DOMNode.COMMENT_NODE) {
      dom.textContent = comment;
      return dom;
    } else {
      var el = doc.createComment(comment);
      return replaceChild(parent, dom, el);
    }
  }

  function applyTextToNode(text : String, dom : DOMNode, parent : Element, post : Array<Void -> Void>) : DOMNode {
    // trace("** applyTextToNode");
    if(dom.nodeType == DOMNode.TEXT_NODE) {
      dom.textContent = text;
      return dom;
    } else {
      var el = doc.createTextNode(text);
      return replaceChild(parent, dom, el);
    }
  }

  function replaceChild(parent : Element, oldDom : DOMNode, newDom : DOMNode) {
    // trace("** replaceChild, is same? " + (oldDom == newDom));
    if(oldDom == newDom)
      return newDom;
    parent.replaceChild(newDom, oldDom);
    return newDom;
  }

  function zipVNodesAndNodeList(vnodes : VNodes, children : js.html.NodeList) : Array<Tuple2<VNode, DOMNode>> {
    var len = thx.Ints.max(vnodes.length, children.length);
    return [for(i in 0...len) Tuple2.of(vnodes[i], children[i])];
  }

  function zipNodeListAndNodeList(left : js.html.NodeList, right : js.html.NodeList) : Array<Tuple2<DOMNode, DOMNode>> {
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
      var srcValue = getAttribute(srcDom, key),
          dstValue = getAttribute(dstDom, key);
      if(srcValue == dstValue) continue;
      setDynamicAttribute(dstDom, key, srcValue);
    }
  }

  public function applyNodeAttributes(attributes : Map<String, AttributeValue>, dom : Element) {
    var domAttrs  = Set.createString([for(i in 0...dom.attributes.length) dom.attributes.item(i).name]),
        vdomAttrs = Set.createString([for(key in attributes.keys()) key]),
        removed   = domAttrs.difference(vdomAttrs);
    for(key in removed) {
      if(hasEvent(dom, key))
        removeEvent(dom, key);
      else
        dom.removeAttribute(key);
    }

    for(key in vdomAttrs) {
      switch attributes.get(key) {
        case null:
          removeAttribute(dom, key);
        case StringAttribute(s) if(null == s && key == "value"):
          setStringAttribute(dom, key, "");
        case StringAttribute(s) if(null == s || s == "" && key != "value"):
          removeAttribute(dom, key);
        case BoolAttribute(b):
          toggleBoolAttribute(dom, key, b);
        case StringAttribute(s):
          setStringAttribute(dom, key, s);
        case EventAttribute(e):
          setEvent(dom, key, e);
      }
    }
  }

  function generateDom(node : VNode, post : Array<Void -> Void>) : DOMNode {
    return switch node {
      case Element(name, attributes, children):
        // trace("** generateDom: element");
        createElement(name, attributes, children, post);
      case Comment(comment):
        // trace("** generateDom: comment");
        doc.createComment(comment);
      case Raw(code):
        // trace("** generateDom: raw");
        dots.Html.parse(code);
      case Text(text):
        // trace("** generateDom: text");
        doc.createTextNode(text);
      case Comp(comp):
        // trace("** generateDom: component");
        comp.willMount();
        var node = renderComponent(comp),
            dom  = generateDom(node, post);
        comp.node = cast dom; // TODO remove cast
        comp.apply = cast this.apply; // TODO remove cast
        post.insert(0, function() comp.didMount()); // TODO remove cast
        domComponentMap.set(cast comp, dom); // TODO remove cast
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
      if(null == child) continue;
      var n = generateDom(child, post);
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

  static function hasEvent(el : js.html.Element, name : String) {
    return Reflect.hasField(el, 'on$name');
  }
}

private class DomComponentMap {
  var domToComponent(default, null) : Map<DOMNode, Array<Component<Dynamic>>>;
  var componentToDom(default, null) : Map<Component<Dynamic>, DOMNode>;
  public function new() {
    componentToDom = new Map();
    domToComponent = new Map();
  }

  public function getComponents(dom : DOMNode) : Array<Component<Dynamic>> {
    if(null == dom) return null;
    return domToComponent.get(dom);
  }

  function getDom(comp : Component<Dynamic>) : DOMNode {
    if(null == comp) return null;
    return componentToDom.get(comp);
  }

  public function set(comp : Component<Dynamic>, dom : DOMNode) {
    componentToDom.set(comp, dom);
    var list = domToComponent.get(dom);
    if(null == list) {
      list = [comp];
      domToComponent.set(dom, list);
    } else {
      list.push(comp);
    }
  }

  public function removeByComponent(comp : Component<Dynamic>) {
    var dom = componentToDom.get(comp);
    componentToDom.remove(comp);
    var list = getComponents(dom);
    if(null == list) return;
    list.remove(comp);
    if(list.length == 0)
      domToComponent.remove(dom);
  }

  public function removeByDom(dom : DOMNode) {
    var comps = getComponents(dom);
    domToComponent.remove(dom);
    if(null == comps) return;
    for(comp in comps) {
      componentToDom.remove(comp);
    }
  }
}
