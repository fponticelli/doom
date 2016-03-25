package doom.core;

import doom.core.VNode;

@:forward(length, iterator, map)
abstract VNodes(Array<VNode>) to Array<VNode> {
  @:from inline public static function child(child : VNode) : VNodes
    return [child];
  @:from inline public static function text(text : String) : VNodes
    return [VNode.text(text)];
  @:from inline public static function comp<Props, El>(comp : Component<Props, El>) : VNodes
    return [VNode.comp(comp)];
  @:from public static function children(children : Array<VNode>) : VNodes
    return new VNodes(children);
  // public static function nodes(children : Array<VNode>) : VNodes
  //   return children.map(VNode.node);

  @:to inline public function toArray() : Array<VNodeImpl>
    return cast this;

  inline function new(arr : Array<VNode>)
    this = arr;

  public function add(child : VNode) : VNodes {
    this.push(child);
    return this;
  }

  inline public function concat(other : VNodes) : VNodes
    return this.concat(other);

  inline public function copy() : VNodes
    return this.copy();

  inline public function filter(predicate : VNode -> Bool) : VNodes
    return this.filter(predicate);
}
