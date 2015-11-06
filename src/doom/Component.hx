package doom;

import js.html.Node as DomNode;
import doom.Node;

class Component<T> {
  var parent : DomNode;
  var element : DomNode;
  var node : Node;
  public function new() {}

  private function render(state : T) : Node
    return throw new thx.error.AbstractMethod();

  public function update(state : T) : Void {
    var oldNode = node,
        newNode = view(state);
    if(null == parent && null == element && null == oldNode)
      throw new thx.Error('component is not mounted');
    if(null == oldNode) {
      element = HtmlNode.toHtml(newNode);
      if(parent.nodeType == DomNode.ELEMENT_NODE)
        (cast parent : js.html.Element).innerHTML = "";
      parent.appendChild(element);
    } else {
      var patches = oldNode.diff(newNode);
      HtmlNode.applyPatches(patches, element);
    }
    node = newNode;
  }

  inline static var create = "create";
  public function view(state : T) : Node {
    node = render(state);
    switch node {
      case Element(_, _, events, _):
        function m(e : js.html.Event) {
          // mount(cast e.target, true);
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
}
