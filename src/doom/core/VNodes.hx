package doom.core;

import doom.core.VNode;

@:forward(length, concat, copy, filter, indexOf, iterator, join, lastIndexOf,
          map, slice)
@:arrayAccess
abstract VNodes(Array<VNode>) from Array<VNode> {
  @:from inline public static function node(node : VNode) : VNodes
    return [node];

  @:from inline public static function nodeImpl(node : VNodeImpl) : VNodes
    return [(node : VNode)];

  @:from inline public static function nodesImpl(nodes : Array<VNodeImpl>) : VNodes
    return cast nodes;

  @:from
  inline public static function comps<Prop, El>(comps : Array<Component<Prop, El>>) : VNodes
    return comps.map(VNode.comp);

  @:from
  inline public static function comment(content : String) : VNodes
    return [VNode.comment(content)];

  @:from
  inline public static function text(content : String) : VNodes
    return [VNode.text(content)];

  @:from
  inline public static function comp<Prop, El>(comp : Component<Prop, El>) : VNodes
    return [VNode.comp(comp)];
}
