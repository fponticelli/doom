package doom.core;

abstract VChild(VChildImpl) from VChildImpl to VChildImpl {
  @:from inline public static function node(node : VNode) : VChild
    return VChildImpl.Node(node);
  @:from inline public static function text(text : String) : VChild
    return VChildImpl.Node(VNode.text(text));
  @:from inline public static function comp<Props, El>(comp : Component<Props, El>) : VChild
    return VChildImpl.Comp(comp);

  inline public function asChildren() : VChildren
    return [this];
}

enum VChildImpl {
  Node(node : VNode);
  Comp<Props, El>(comp : Component<Props, El>);
}
