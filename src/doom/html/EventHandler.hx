package doom.html;

import js.html.Element;
import js.html.Event;
import thx.Floats;
import thx.Ints;

@:callable
abstract EventHandler(Element -> Event -> Void) from Element -> Event -> Void to Element -> Event -> Void {
  @:from inline static public function fromHandler(f: Void -> Void): EventHandler
    return function(el: Element, e: Event) {
      e.preventDefault();
      f();
    };

  @:from inline static public function fromEventHandler<T: Event>(f: T -> Void): EventHandler
    return function(_: Element, e: Event) {
      f(cast e);
    };

  @:from inline static public function fromElementHandler<T: Element>(f: T -> Void): EventHandler
    return function(el: Element, e: Event) {
      e.preventDefault();
      var typedEl: T = cast el;
      f(typedEl);
    };

  @:from inline static public function fromElementAndEventHandler<TEL: Element, TE: Event>(f: TEL -> TE -> Void): EventHandler
    return function(el: Element, e: Event) {
      f(cast el, cast e);
    };

  @:from inline static public function fromStringValueHandler(f: String -> Void): EventHandler
    return function(el: Element, e: Event) {
      e.preventDefault();
      var value: String = dots.Dom.getValue(el);
      f(value);
    };

  @:from inline static public function fromStringValueAndEventHandler<TE: Event>(f: String -> TE -> Void): EventHandler
    return function(el: Element, e: Event) {
      var value: String = dots.Dom.getValue(el);
      f(value, cast e);
    };

  @:from inline static public function fromBoolValueHandler(f: Bool -> Void): EventHandler
    return function(el: Element, e: Event) {
      e.preventDefault();
      var value: Bool = (cast el: js.html.InputElement).checked;
      f(value);
    };

  @:from inline static public function fromBoolValueAndEventHandler<TE: Event>(f: Bool -> TE -> Void): EventHandler
    return function(el: Element, e: Event) {
      var value: Bool = (cast el: js.html.InputElement).checked;
      f(value, cast e);
    };

  @:from inline static public function fromFloatValueHandler(f: Float -> Void): EventHandler
    return fromStringValueHandler(function(s: String) {
      if(Floats.canParse(s)) f(Floats.parse(s));
    });

  @:from inline static public function fromFloatValueAndEventHandler<TE: Event>(f: Float -> TE -> Void): EventHandler
    return fromStringValueAndEventHandler(function(s: String, e: TE) {
      if(Floats.canParse(s)) f(Floats.parse(s), e);
    });

  @:from inline static public function fromIntValueHandler(f: Int -> Void): EventHandler
    return fromStringValueHandler(function(s: String) {
      if(Ints.canParse(s)) f(Ints.parse(s));
    });

  @:from inline static public function fromIntValueAndEventHandler<TE: Event>(f: Int -> TE -> Void): EventHandler
    return fromStringValueAndEventHandler(function(s: String, e: TE) {
      if(Ints.canParse(s)) f(Ints.parse(s), e);
    });
}
