package doom;

import js.html.Node as DomNode;
import doom.Node;
using doom.Patch;

class Component2<T> {
  var parent : DomNode;
  var element : DomNode;
  var node : Node;
  public function new() {}

  private function render(state : T) : Node
    return throw new thx.error.AbstractMethod();

  public function update(state : T) : Void {
    trace('UPDATE', state);
    var oldNode = node,
        newNode = view(state);
    if(null == oldNode) {
      if(null == parent)
        throw new ComponentError('component is not mounted', this);
      element = HtmlNode.toHtml(newNode);
      if(parent.nodeType == DomNode.ELEMENT_NODE)
        (cast parent : js.html.Element).innerHTML = "";
      trace("CREATE");
      //trace(newNode.toString());
      trace(untyped element.outerHTML);
      parent.appendChild(element);
    } else {
      trace("PATCH?", toString(), oldNode.toString(), newNode.toString(), null != element);
      if(null == element)
        return;
        //throw new ComponentError('component lost reference', this);
      var patches = oldNode.diff(newNode);

      trace("PATCH", patches.toPrettyString());
      trace("HTML BEFORE PATCH", untyped element.outerHTML);
      HtmlNode.applyPatches(patches, element);
      trace("HTML AFTER PATCH", untyped element.outerHTML);
    }
    node = newNode;
  }

  inline static var create = "create";
  public function view(state : T) : Node {
    trace("VIEW", toString(), "element exits?", element != null);
    node = render(state);
    trace("RENDERED", toString());
    switch node {
      case Element(_, _, events, _): // if(element == null):
        function m(e : js.html.Event) {
          trace("VIEW MOUNT", toString());
          element = cast e.target;
          if(null == parent)
            parent = element.parentNode;
          else
            parent.appendChild(element);
        }
        if(events.exists(create)) {
          var old = events.get(create);
          events.set(create, function(e) {
            old(e);
            m(e);
          });
        } else {
          events.set(create, m);
        }
      case _:
    }
    return node;
  }

  public function mount(parent : DomNode) {
    this.parent = parent;
    return this;
  }

  public function toString() {
    var cls = Type.getClassName(Type.getClass(this)).split(".").pop();
    var state = null == node ? "never rendered" : node.toString();
    return '$cls($state)';
  }
}
