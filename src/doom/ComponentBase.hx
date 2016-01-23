package doom;

import doom.Node.Nodes;
import js.html.Element;
using thx.Strings;

class ComponentBase implements IComponent {
  public var element : Element;
  public var node : Node;
  public var children : Nodes;

  public function new(?children : Nodes) {
    this.children = null == children ? [] : children;
    this.node = render();
  }

  public function init(post : Array<Void -> Void>) {
    // if(null != element)
    //   trace("double init", toString());
    post.insert(0, didMount);
    element = cast HtmlNode.toHtml(node, post);
  }

  public function render() : Node {
    return throw new thx.error.AbstractMethod();
  }

  public function didMount() {}
  public function didRefresh() {}
  public function didUnmount() {}

  public function toString() {
    var cls = Type.getClassName(Type.getClass(this)).split(".").pop();
    return '$cls(${node.toString().ellipsisMiddle(80, "...")})';
  }

  private function updateNode(oldNode : Node) {
    var newNode = render();
    switch newNode {
      case doom.Node.NodeImpl.Element(_): // do nothing
      case doom.Node.NodeImpl.ComponentNode(_):
      case _: throw new thx.Error('Component ${toString()} must return only element nodes');
    }
    var patches = oldNode.diff(newNode);
    // trace(patches.map(doom.Patch.Patches.toString).join("\n"));
    HtmlNode.applyPatches(patches, element);
    node = newNode;
  }
}
