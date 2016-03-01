package doom.core;

import doom.core.Component;

abstract VNode(VNodeImpl) from VNodeImpl to VNodeImpl {
  @:from inline static public function text(s : String) : VNode
    return Text(s);
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

  @:to inline public function asChild() : VChild
    return VChild.node(this);

  @:to inline public function asChildren() : VChildren
    return [VChild.node(this)];

  // TODO
  //   * toString (requires XML backend)
}

enum VNodeImpl {
  Element(
    name : String,
    attributes : Map<String, AttributeValue>,
    children : VChildren);
  Comment(comment : String);
  Raw(code : String);
  Text(text : String);
}
