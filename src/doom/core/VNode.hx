package doom.core;

import doom.core.Component;

abstract VNode(VNodeImpl) from VNodeImpl to VNodeImpl {
  @:from inline static public function fromString(s : String) : VNode
    return Text(s);
  @:from inline static public function fromComp<Props, EL>(comp : Component<Props, EL>) : VNode
    return ComponentNode(comp);
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
