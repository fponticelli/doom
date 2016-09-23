package doom.core;

abstract VNode(VNodeImpl) from VNodeImpl to VNodeImpl {
  @:from inline public static function text(text: String): VNode
    return VNodeImpl.Text(text);
  @:from inline public static function comp<Props, El>(comp: Component<Props, El>): VNode
    return VNodeImpl.Comp(comp);
  inline public static function raw(content: String): VNode
    return Raw(content);
  inline public static function comment(content: String): VNode
    return Comment(content);
  public static function el(name: String,
    ?attributes: Map<String, AttributeValue>,
    ?children: VNodes): VNode {
    if(null == attributes)
      attributes = new Map();
    if(null == children)
      children = [];
    return Element(name, attributes, children);
  }

  @:from inline public static function lazy(fn: Void -> VNode): VNode
    return VNodeImpl.Lazy(fn);

  @:from inline public static function renderable(r: Renderable): VNode
    return VNodeImpl.Lazy(r.render);

  @:to inline public function asNodes(): VNodes
    return [this];
}

enum VNodeImpl {
  Element(
    name: String,
    attributes: Map<String, AttributeValue>,
    children: VNodes);
  Comment(comment: String);
  Raw(code: String);
  Text(text: String);
  Comp<Props, El>(comp: Component<Props, El>);
  Lazy(render: Void -> VNode);
}
