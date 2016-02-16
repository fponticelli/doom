package doom.html;

import haxe.Constraints;
import js.html.Element;
import js.html.Event;

@:callable
abstract EventHandler(Function) from Function to Function {
  @:from public static function fromElementHandler(f : Element -> Void) : EventHandler
    return function(e : Event) f(cast e.target);
}
