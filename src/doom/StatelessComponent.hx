package doom;

import js.html.Element;
using doom.Patch;

class StatelessComponent implements IComponent {
  public var element : Element;
  public var node : Node;

  public function new() {
    this.node = render();
  }

  public function init() {
    // TODO should this be js.html.Node
    element = cast HtmlNode.toHtml(node);
  }

  private function updateNode(oldNode : Node) {
    var newNode = render(),
        patches = oldNode.diff(newNode);
    HtmlNode.applyPatches(patches, element);
    node = newNode;
  }

  private function render() : Node
    return throw new thx.error.AbstractMethod();

  public function update() {
    updateNode(node);
  }

  public function toString() {
    var cls = Type.getClassName(Type.getClass(this)).split(".").pop();
    return '$cls(${node.toString()})';
  }
}
