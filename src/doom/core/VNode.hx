package doom.core;

using thx.Functions;

abstract VNode(VNodeImpl) from VNodeImpl to VNodeImpl {
  @:from inline public static function text(text: String): VNode
    return VNodeImpl.Text(text, null, null);
  @:from inline public static function comp<Props, El>(comp: Component<Props, El>): VNode
    return VNodeImpl.Comp(comp);
  inline public static function raw(content: String): VNode
    return Raw(content, null, null);
  inline public static function comment(content: String): VNode
    return Comment(content, null, null);
  public static function el<El>(name: String,
    ?attributes: Map<String, AttributeValue>,
    ?children: VNodes
  ): VNode {
    if(null == attributes)
      attributes = new Map();
    if(null == children)
      children = [];
    return Element(name, attributes, children, null, null);
  }

  @:from inline public static function lazy(fn: Void -> VNode): VNode
    return VNodeImpl.Lazy(fn);

  @:from inline public static function renderable(r: Renderable): VNode
    return VNodeImpl.Lazy(r.render);

  @:to inline public function asNodes(): VNodes
    return [this];

  public function mount<Render, El>(mount: Render -> El -> Void): VNode {
    return switch this {
      case Element(name, attributes, children, null, onUnmount):
        Element(name, attributes, children, cast mount, cast onUnmount);
      case Element(name, attributes, children, onMount, onUnmount):
        Element(name, attributes, children, onMount.join(cast mount), cast onUnmount);
      case Comment(comment, null, onUnmount):
        Comment(comment, cast mount, cast onUnmount);
      case Comment(comment, onMount, onUnmount):
        Comment(comment, onMount.join(cast mount), cast onUnmount);
      case Raw(code, null, onUnmount):
        Raw(code, cast mount, cast onUnmount);
      case Raw(code, onMount, onUnmount):
        Raw(code, onMount.join(cast mount), cast onUnmount);
      case Text(text, null, onUnmount):
        Text(text, cast mount, onUnmount);
      case Text(text, onMount, onUnmount):
        Text(text, onMount.join(cast mount), onUnmount);
      case Comp(comp):
        throw new thx.Error('Component does not support `onMount`, use `Component.didMount` or `Component.willMount`');
      case Lazy(render):
        Lazy(function() {
          var node = render();
          return node.mount(mount);
        });
    };
  }

  // // TODO needs implementation in Render
  // public function onUnmount<El>(unmount: El -> Void): VNode {
  //   return switch this {
  //     case Element(name, attributes, children, onMount, null):
  //       Element(name, attributes, children, onMount, cast unmount);
  //     case Element(name, attributes, children, onMount, onUnmount):
  //       Element(name, attributes, children, onMount, onUnmount.join(cast unmount));
  //     case Comment(comment, onMount, null):
  //       Comment(comment, onMount, cast unmount);
  //     case Comment(comment, onMount, onUnmount):
  //       Comment(comment, unmount, onUnmount.join(cast unmount));
  //     case Raw(code, onMount, null):
  //       Raw(code, onMount, cast unmount);
  //     case Raw(code, onMount, onUnmount):
  //       Raw(code, cast onMount, onUnmount.join(cast unmount));
  //     case Text(text, onMount, null):
  //       Text(text, onMount, cast unmount);
  //     case Text(text, onMount, onUnmount):
  //       Text(text, onMount, onUnmount.join(cast unmount));
  //     case Comp(comp):
  //       throw new thx.Error('Component does not support `onMount`, use `Component.didMount` or `Component.willMount`');
  //     case Lazy(render):
  //       Lazy(function() {
  //         var node = render();
  //         return node.onUnmount(unmount);
  //       });
  //   };
  // }
}

enum VNodeImpl {
  Element<Render, El>(
    name: String,
    attributes: Map<String, AttributeValue>,
    children: VNodes,
    onMount: Null<MountF<Render, El>>,
    onUnmount: Null<MountF<Render, El>>
  );
  Comment<Render, C>(comment: String, onMount: Null<MountF<Render, C>>, onUnmount: Null<MountF<Render, C>>);
  Raw<Render, R>(code: String, onMount: Null<MountF<Render, R>>, onUnmount: Null<MountF<Render, R>>);
  Text<Render, T>(text: String, onMount: Null<MountF<Render, T>>, onUnmount: Null<MountF<Render, T>>);
  Comp<Props, El>(comp: Component<Props, El>);
  Lazy(render: Void -> VNode);
}

typedef MountF<Render, Element> = Render -> Element -> Void;
