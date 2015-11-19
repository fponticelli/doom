package doom;

import js.html.Event;
import js.html.KeyboardEvent;
import js.html.InputElement;

abstract AttributeValue(AttributeValueImpl) from AttributeValueImpl to AttributeValueImpl {
  @:from static public function fromString(s : String) : AttributeValue
    return StringAttribute(s);

  @:from static public function fromMap(map : Map<String, Bool>) : AttributeValue {
    var values = [];
    for(key in map.keys())
      if(map.get(key))
        values.push(key);
    return StringAttribute(values.join(" "));
  }

  @:from static public function fromBool(b : Bool) : AttributeValue
    return BoolAttribute(b);

  @:from static public function fromEventHandler(f : Event -> Void) : AttributeValue
    return EventAttribute(f);

  @:from static public function fromKeyboardEventHandler(f : KeyboardEvent -> Void) : AttributeValue
    return EventAttribute(f);

  @:from static public function fromInputElementHandler(f : InputElement -> Void) : AttributeValue
    return EventAttribute(function(e : Event) {
      var input : InputElement = cast e.target;
      f(input);
    });

  @:op(A==B)
  public function equalsTo(that : AttributeValue)
    return switch [this, that] {
      case [BoolAttribute(a), BoolAttribute(b)]: a == b;
      case [StringAttribute(a), StringAttribute(b)]: a == b;
      case [_, _]: false;
    };

  @:op(A!=B)
  public function notEqualsTo(that : AttributeValue)
    return !equalsTo(that);
}

enum AttributeValueImpl {
  BoolAttribute(b : Bool);
  StringAttribute(s : String);
  EventAttribute<T : Event>(f : T -> Void);
}
