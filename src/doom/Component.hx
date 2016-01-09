package doom;

import js.html.Element;
using doom.Patch;
using thx.Strings;
import doom.Node;

class Component<Api, State> extends ComponentBase {
  public var api : Api;
  public var state : State;

  public function new(api : Api, state : State) {
    this.api = api;
    this.state = state;
    super();
  }

  public function update(newState : State) {
    var oldState = this.state;
    this.state = newState;
    if(!shouldRender(oldState, newState))
      return;
    updateNode(node);
  }

  public function shouldRender(oldState : State, newState : State)
    return true;
}
