package doom.core;

import js.html.Event;
import js.html.Element;
import thx.Error;
import thx.Ints;
import thx.Floats;

abstract AttributeValue(AttributeValueImpl) from AttributeValueImpl to AttributeValueImpl {
  @:from static public function fromString(s: String): AttributeValue
    return StringAttribute(s);

  @:from static public function fromBoolMap(map: Map<String, Bool>): AttributeValue {
    var values = [];
    for(key in map.keys())
      if(map.get(key))
        values.push(key);
    return StringAttribute(values.join(" "));
  }

  @:from static public function fromStringMap(map: Map<String, String>): AttributeValue {
    var values = [];
    for(key in map.keys()) {
      var value = map.get(key);
      if(null == value) continue;
      values.push('$key:$value');
    }
    return StringAttribute(values.join(";"));
  }

  @:from static public function fromBool(b: Bool): AttributeValue
    return BoolAttribute(b);

  @:from static public function fromEventHandler<EL: Element, E: Event>(f: doom.html.EventHandler): AttributeValue
    return null == f ? BoolAttribute(false): EventAttribute(f);

  @:from inline static public function fromHandler(f: Void -> Void): AttributeValue
    return fromEventHandler(f);

  @:from inline static public function fromTypedEventHandler<T: Event>(f: T -> Void): AttributeValue
    return fromEventHandler(f);

  @:from inline static public function fromElementHandler<T: Element>(f: T -> Void): AttributeValue
    return fromEventHandler(f);

  @:from inline static public function fromElementAndEventHandler<TEL: Element, TE: Event>(f: TEL -> TE -> Void): AttributeValue
    return fromEventHandler(f);

  @:from inline static public function fromStringValueHandler(f: String -> Void): AttributeValue
    return fromEventHandler(f);

  @:from inline static public function fromStringValueAndEventHandler<TE: Event>(f: String -> TE -> Void): AttributeValue
    return fromEventHandler(f);

  @:from inline static public function fromBoolValueHandler(f: Bool -> Void): AttributeValue
    return fromEventHandler(f);

  @:from inline static public function fromBoolValueAndEventHandler<TE: Event>(f: Bool -> TE -> Void): AttributeValue
    return fromEventHandler(f);

  @:from inline static public function fromIntValueHandler(f: Int -> Void): AttributeValue
    return fromEventHandler(f);

  @:from inline static public function fromIntValueAndEventHandler<TE: Event>(f: Int -> TE -> Void): AttributeValue
    return fromEventHandler(f);

  @:from inline static public function fromFloatValueHandler(f: Float -> Void): AttributeValue
    return fromEventHandler(f);

  @:from inline static public function fromFloatValueAndEventHandler<TE: Event>(f: Float -> TE -> Void): AttributeValue
    return fromEventHandler(f);

  public function toString(): String
    return switch this {
      case StringAttribute(s): s;
      case a: throw new Error('cannot convert attribute $a to string');
    };

  @:op(A==B)
  public function equalsTo(that: AttributeValue)
    return switch [this, that] {
      case [null, _], [_, null]: false;
      case [BoolAttribute(a), BoolAttribute(b)]: a == b;
      case [StringAttribute(a), StringAttribute(b)]: a == b;
      case [_, _]: false;
    };

  @:op(A!=B)
  public function notEqualsTo(that: AttributeValue)
    return !equalsTo(that);
}

enum AttributeValueImpl {
  BoolAttribute(b: Bool);
  StringAttribute(s: String);
  EventAttribute<EL: Element, E: Event>(f: EL -> E -> Void);
}
