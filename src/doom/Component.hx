package doom;

import js.html.Node as DomNode;
import doom.Node;

class Component<T> {
  var mountNode : DomNode;
  var node : Node;
  public function new() {}

  private function render(state : T) : Node
    return throw new thx.error.AbstractMethod();

  public function update(state : T) : Void {
    var oldNode = node,
        newNode = view(state);
    if(null == mountNode)
      throw new thx.Error('component is not mounted');
    if(null == oldNode) {
      var parent = mountNode.parentNode,
          el = HtmlNode.toHtml(node);
      parent.insertBefore(el, mountNode);
      parent.removeChild(mountNode);
      mountNode = el;
    } else {
      var patches = oldNode.diff(newNode);
      HtmlNode.applyPatches(patches, mountNode);
    }
  }

  inline static var beforeMount = "create";
  public function view(state : T) : Node {
    node = render(state);
    switch node {
      case Element(_, _, events, _):
        function m(e : js.html.Event) {
          mount(cast e.target);
        }
        if(events.exists(beforeMount)) {
          var old = events.get(beforeMount);
          events.set(beforeMount, function(e) {
            m(e);
            old(e);
          });
        } else {
          events.set(beforeMount, m);
        }
      case _:
    }
    return node;
  }

  public function mount(node : DomNode) {
    mountNode = node;
    if(mountNode.nodeType == DomNode.ELEMENT_NODE)
      (cast mountNode : js.html.Element).innerHTML = "";
    return this;
  }
}
