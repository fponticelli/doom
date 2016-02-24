package doom.core;

class Component<Props, El> {
  public var props(default, null) : Props;
  public var children(default, null) : Null<VChildren>;
  public var node(default, null) : El;
  public var isUnmounted(default, null) : Bool = false;
  public var apply(default, null) : VChild -> El -> Void;

  public function new(props : Props, ?children : VChildren) {
    this.props = props;
    this.children = children;
  }

  public function render() : VNode {
    return throw new thx.error.AbstractMethod();
  }

  public function asChild() : VChild
    return this;

  public function update(props : Props) {
    var old = this.props;
    this.props = props;
    // trace("** update, shouldUpdate? " + shouldUpdate(old, props) + ", shouldRender? " + shouldRender());
    if(!shouldUpdate(old, props) || !shouldRender())
      return;
    apply(this, node);
  }

  public function shouldUpdate(oldProps : Props, newProps : Props) {
    return true;
  }

  public function shouldRender() {
    return !isUnmounted;
  }

  public function migrationFields()
    return ["props", "update", "children"];

  public function didMount() {}
  public function willMount() {}

  public function willUpdate() {}
  public function didUpdate() {}

  public function didUnmount() {}
  public function willUnmount() {}
}
