package doom.core;

class Component<Api, State> {
  public var api(default, null) : Api;
  public var state(default, null) : State;
  public var children(default, null) : VNodes;
  function new(api : Api, state : State, children : VNodes) {
    this.api = api;
    this.state = state;
    this.children = children;
  }

  public function render() : VNode {
    return throw new thx.error.AbstractMethod();
  }

  public function didMount() {}
  public function willMount() {}

  public function didUnmount() {}
  public function willUnmount() {}
}
