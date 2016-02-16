package doom.core;

class Component<Props, El> {
  public var props(default, null) : Props;
  public var children(default, null) : VNodes;
  public var element(default, null) : El;
  public var doom : IRender<El>;

  public function new(props : Props, children : VNodes) {
    this.props = props;
    this.children = children;
  }

  public function render() : VNode {
    return throw new thx.error.AbstractMethod();
  }

  public function update(props : Props) {
    if(!shouldUpdate(this.props, props))
      return;
    this.props = props;
    var node = render();
    doom.apply(node, element);
  }

  public function shouldUpdate(oldProps : Props, newProps : Props) {
    return true;
  }

  public function didMount() {}
  public function willMount() {}

  public function didUnmount() {}
  public function willUnmount() {}
}
