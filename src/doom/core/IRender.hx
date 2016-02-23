package doom.core;

interface IRender<T> {
  function apply(node : VChild, dom : T) : Void;
}
