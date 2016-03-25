package doom.core;

using thx.Strings;
import thx.Error;

class Component<Props, El> {
  public var props(default, null) : Props;
  public var children(default, null) : Null<VNodes>;
  public var node(default, null) : El;
  public var isUnmounted(default, null) : Bool = false;
  public var apply(default, null) : VNode -> El -> Void;

  public function new(props : Props, ?children : VNodes) {
    this.props = props;
    this.children = children;
  }

  public function render() : VNode {
    return throw new thx.error.AbstractMethod();
  }

  public function asChild() : VNode
    return this;

  public function update(props : Props) {
    var old = this.props;
    this.props = props;
    // trace("** update, shouldUpdate? " + shouldUpdate(old, props) + ", shouldRender? " + shouldRender());
    if(!shouldUpdate(old, props) || !shouldRender())
      return;
    try {
      apply(this, node);
    } catch(e : Dynamic) {
      rethrowUpdateError(e);
    }
  }

  function rethrowUpdateError(e : Dynamic) {
    var s = Std.string(e);
    if(s.contains("apply is not a function")) {
      throw new Error('method `apply` has not been correctly migrated to ${Type.getClassName(Type.getClass(this))}');
    } else {
      throw Error.fromDynamic(e);
    }
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
