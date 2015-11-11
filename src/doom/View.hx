package doom;

import js.html.Node as DomNode;
import js.html.Element as DomElement;
import doom.Node;
using doom.Patch;

class View<T> {
  var element : DomNode;
  var node : Node;
  public function new(ref : DomElement, state : T) {
    node = render(state);
    element = HtmlNode.toHtml(node);
    ref.innerHTML = "";
    ref.appendChild(element);
  }

  private function render(state : T) : Node
    return throw new thx.error.AbstractMethod();

  public function update(state : T) : Void {
    trace('UPDATE', state);
    var newNode = render(state);

    trace("PATCH?", toString(), node.toString(), newNode.toString(), null != element);
    var patches = node.diff(newNode);

    trace("PATCH", patches.toPrettyString());
    trace("HTML BEFORE PATCH", untyped element.outerHTML);
    HtmlNode.applyPatches(patches, element);
    trace("HTML AFTER PATCH", untyped element.outerHTML);
    node = newNode;
  }

  public function toString() {
    var cls = Type.getClassName(Type.getClass(this)).split(".").pop();
    var state = node.toString();
    return '$cls($state)';
  }
}
