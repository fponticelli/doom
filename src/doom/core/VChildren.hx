package doom.core;

import doom.core.VChild;

@:forward(length, iterator, map)
abstract VChildren(Array<VChild>) to Array<VChild> {
  @:from inline public static function child(child : VChild) : VChildren
    return [child];
  @:from inline public static function node(node : VNode) : VChildren
    return [VChild.node(node)];
  @:from inline public static function text(text : String) : VChildren
    return [VChild.node(VNode.text(text))];
  @:from inline public static function comp<Props, El>(comp : Component<Props, El>) : VChildren
    return [VChild.comp(comp)];
  @:from public static function children(children : Array<VChild>) : VChildren
    return new VChildren(children);
  public static function nodes(children : Array<VNode>) : VChildren
    return children.map(VChild.node);

  @:to inline public function toArray() : Array<VChildImpl>
    return cast this;

  inline function new(arr : Array<VChild>)
    this = arr;

  public function add(child : VChild) : VChildren {
    this.push(child);
    return this;
  }

  inline public function concat(other : VChildren) : VChildren
    return this.concat(other);

  inline public function copy() : VChildren
    return this.copy();

  inline public function filter(predicate : VChild -> Bool) : VChildren
    return this.filter(predicate);
}
