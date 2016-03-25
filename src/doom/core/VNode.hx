package doom.core;

abstract VNode(VNodeImpl) from VNodeImpl to VNodeImpl {
  // @:from inline public static function node(node : VNode) : VNode
  //   return VNodeImpl.Node(node);
  @:from inline public static function text(text : String) : VNode
    return VNodeImpl.Text(text);
  @:from inline public static function comp<Props, El>(comp : Component<Props, El>) : VNode
    return VNodeImpl.Comp(comp);

  // @:from inline static public function text(s : String) : VNode
  //   return Text(s);
  inline public static function raw(content : String) : VNode
    return Raw(content);
  inline public static function comment(content : String) : VNode
    return Comment(content);
  public static function el(name : String,
    ?attributes : Map<String, AttributeValue>,
    ?children : VNodes) : VNode {
    if(null == attributes)
      attributes = new Map();
    if(null == children)
      children = [];
    return Element(name, attributes, children);
  }

  @:to inline public function asChildren() : VNodes
    return [this];
}

enum VNodeImpl {
  Element(
    name : String,
    attributes : Map<String, AttributeValue>,
    children : VNodes);
  Comment(comment : String);
  Raw(code : String);
  Text(text : String);
  Comp<Props, El>(comp : Component<Props, El>);
}
