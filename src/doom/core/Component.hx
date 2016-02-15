package doom.core;

class Component<Props, El> {
  public var props(default, null) : Props;
  public var children(default, null) : VNodes;
  function new(props : Props, children : VNodes) {
    this.props = props;
    this.children = children;
  }

  public function render() : VNode {
    return throw new thx.error.AbstractMethod();
  }

  public function didMount(el : El) {}
  public function willMount() {}

  public function didUnmount() {}
  public function willUnmount() {}
}
