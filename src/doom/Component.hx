package doom;

import js.html.Element;
using doom.Patch;

class Component<State> implements IComponent {
  public static function mount(component : IComponent, ref : Element) {
    if(null == ref)
      throw 'reference element is set to null';
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
    switch newNode {
      case doom.Node.NodeImpl.Element(_): // do nothing
      case _: throw new thx.Error('Component can (and must) return only element nodes');
    }
    var patches = oldNode.diff(newNode);
    HtmlNode.applyPatches(patches, element);
    node = newNode;
  }

  private function render() : Node
    return throw new thx.error.AbstractMethod();

  public function update(newState : State) {
    var oldState = this.state;
    this.state = newState;
    if(!shouldRender(oldState, newState))
      return;
    updateNode(node);
  }

  public function shouldRender(oldState : State, newState : State)
    return true;

  public function toString() {
    var cls = Type.getClassName(Type.getClass(this)).split(".").pop();
    return '$cls(${node.toString()})';
  }
}
