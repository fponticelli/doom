package doom;

import js.html.Element;
using doom.Patch;

class Component<State> {
  public static function mount<T>(component : Component<T>, ref : Element) {
    ref.innerHTML = "";
    component.init();
    ref.appendChild(component.element);
  }

  public var element : Element;
  public var node : Node;
  public var state : State;

  public function new(state : State) {
    this.state = state;
    this.node = render();
  }

  public function init() {
    // TODO should this be js.html.Node
    element = cast HtmlNode.toHtml(node);
  }

  private function updateNode(oldNode : Node) {
    var newNode = render();
    //trace('updateNode'); //, oldNode, newNode);
    var patches = oldNode.diff(newNode);
    //trace(patches.toPrettyString());
    HtmlNode.applyPatches(patches, element);
    node = newNode;
  }

  private function render() : Node
    return throw new thx.error.AbstractMethod();

  public function update(state : State) {
    this.state = state;
    //trace('update');
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
