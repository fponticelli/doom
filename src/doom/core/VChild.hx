package doom.core;

abstract VChild(VChildImpl) from VChildImpl to VChildImpl {
  // @:from inline public static function node(node : VNode) : VChild
  //   return VChildImpl.Node(node);
  @:from inline public static function text(text : String) : VChild
    return VChildImpl.Text(text);
  @:from inline public static function comp<Props, El>(comp : Component<Props, El>) : VChild
    return VChildImpl.Comp(comp);

  // @:from inline static public function text(s : String) : VNode
  //   return Text(s);
  inline public static function raw(content : String) : VNode
    return Raw(content);
  inline public static function comment(content : String) : VNode
    return Comment(content);
  public static function el(name : String,
    ?attributes : Map<String, AttributeValue>,
    ?children : VChildren) : VNode {
    if(null == attributes)
      attributes = new Map();
    if(null == children)
      children = [];
    return Element(name, attributes, children);
  }

  @:to inline public function asChildren() : VChildren
    return [this];
}

enum VChildImpl {
  Element(
    name : String,
    attributes : Map<String, AttributeValue>,
    children : VChildren);
  Comment(comment : String);
  Raw(code : String);
  Text(text : String);
  Comp<Props, El>(comp : Component<Props, El>);
}
