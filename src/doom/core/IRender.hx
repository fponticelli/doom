package doom.core;

interface IRender<T> {
  function render(node : VNode, parent : T) : Void;
}
