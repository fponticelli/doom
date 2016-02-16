package doom.core;

@:forward(length, concat, copy, filter, indexOf, iterator, join, lastIndexOf,
          map, slice)
abstract VNodes(Array<VNode>) from Array<VNode> {

}
