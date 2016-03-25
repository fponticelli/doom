package doom.core;

interface IRender<T> {
  function apply(node : VNode, dom : T) : Void;
}
