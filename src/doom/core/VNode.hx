package doom.core;

enum VNode {
  Element(
    name : String,
    attributes : Map<String, AttributeValue>,
    children : Array<VNode>);
  Comment(comment : String);
  Raw(code : String);
  Text(text : String);
  ComponentNode<Props, El>(comp : Component<Props, El>);
}
