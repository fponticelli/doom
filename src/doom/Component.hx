package doom;

import js.html.Element;

class Component<State> {
  public var element : Element;
  public var node : Node;
  public var state : State;

  public function new(state : State) {
    this.state = state;
  }

  public function init() {
    this.node = render();
    // TODO should this be js.html.Node
    this.element = cast HtmlNode.toHtml(node);
  }

  public function migrate(element : Element, oldNode : Node) {
    this.element = element;
    updateNode(oldNode);
  }

  private function updateNode(oldNode : Node) {
    var newNode = render();
    var patches = oldNode.diff(newNode);
    HtmlNode.applyPatches(patches, element);
    node = newNode;
  }

  private function render() : Node
    return throw new thx.error.AbstractMethod();

  public function update(state : State) {
    this.state = state;
    if(!shouldRender(this.state, state))
      return;
    updateNode(node);
  }

  public function shouldRender(oldState : State, newState : State)
    return true;

  public function toString() {
    var cls = Type.getClassName(Type.getClass(this)).split(".").pop();
    var state = node.toString();
    return '$cls($state)';
  }
}
