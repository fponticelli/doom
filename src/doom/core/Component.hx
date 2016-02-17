package doom.core;

class Component<Props, El> {
  public var props(default, null) : Props;
  public var children(default, null) : Null<VNodes>;
  public var element(default, null) : El;
  public var isUnmounted(default, null) : Bool = false;
  public var apply(default, null) : VNode -> El -> Void;

  public function new(props : Props, ?children : VNodes) {
    this.props = props;
    this.children = children;
  }

  public function render() : VNode {
    return throw new thx.error.AbstractMethod();
  }

  public function asNode() : VNode
    return VNode.comp(this);

  dynamic public function update(props : Props) {
    if(!shouldUpdate(this.props, props))
      return;
    this.props = props;
    apply(VNode.comp(this), element);
  }

  public function shouldUpdate(oldProps : Props, newProps : Props) {
    return !isUnmounted;
  }

  public function didMount() {}
  public function willMount() {}

  public function didUnmount() {}
  public function willUnmount() {}
}
