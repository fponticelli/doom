package doom.core;

import doom.core.Component;

abstract VNode(VNodeImpl) from VNodeImpl to VNodeImpl {
  @:from inline static public function text(s : String) : VNode
    return Text(s);
  @:from inline static public function comp<Props, EL>(comp : Component<Props, EL>) : VNode
    return ComponentNode(comp);
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

  // TODO
  //   * toString (requires XML backend)
}

enum VNodeImpl {
  Element(
    name : String,
    attributes : Map<String, AttributeValue>,
    children : VNodes);
  Comment(comment : String);
  Raw(code : String);
  Text(text : String);
  ComponentNode<Props, El>(comp : Component<Props, El>);
}
