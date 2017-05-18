import utest.UTest;

import TestAll.TextAttribute.*;
import TestAll.BoolAttribute.*;

class TestAll {
  static function main() {
    UTest.run([
      // new doom.core.TestInference(),
      // new doom.html.TestAttributes(),
      // new doom.html.TestRender(),
      // new doom.html.TestComponent(),
      // new doom.html.TestStream(),
      // new doom.html.TestStyles(),
      new TestAll()
      // new TestPlayGround(),
    ]);
    // doom.html.Css.save("bin/styles.css");
  }

  public function new() {}

  public function testSnippet() {
    var a = [cls & "my-class", id & "my-id", enabled & false];
    trace(a);

    div.id().cls().children();
  }
}

enum TextAttributeImpl {
  ClassName;
  Id;
}

enum BoolAttributeImpl {
  Enabled;
}

enum AttributeImpl {
  TextAttribute(tag: TextAttributeImpl, value: String);
  BoolAttribute(tag: BoolAttributeImpl, value: Bool);
}

abstract TextAttribute(TextAttributeImpl) {
  public static var cls(get, never): TextAttribute;
  public static var id(get, never): TextAttribute;

  function new(ta: TextAttributeImpl)
    this = ta;

  static function get_cls(): TextAttribute
    return new TextAttribute(ClassName);
  static function get_id(): TextAttribute
    return new TextAttribute(Id);

  @:op(A&B) function set(value: String): AttributeImpl
    return TextAttribute(this, value);
}

abstract BoolAttribute(BoolAttributeImpl) {
  public static var enabled(get, never): BoolAttribute;

  function new(ta: BoolAttributeImpl)
    this = ta;

  static function get_enabled(): BoolAttribute
    return new BoolAttribute(Enabled);

  @:op(A&B) function set(value: Bool): AttributeImpl
    return BoolAttribute(this, value);
}
