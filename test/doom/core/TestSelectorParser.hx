package doom.core;

import doom.core.*;
import doom.core.SelectorParser.SelectorParserResult;
import utest.Assert;
using thx.Iterators;
using thx.Maps;

class TestSelectorParser {
  public function new() {}

  public function testParseSelectorEmpty() {
    var result = SelectorParser.parseSelector("");
    assertTag("div", result);
    assertNoAttrs(result);
  }

  public function testParseSelectorTag() {
    var result = SelectorParser.parseSelector("span");
    assertTag("span", result);
    assertNoAttrs(result);
  }

  public function testParseSelectorId() {
    var result = SelectorParser.parseSelector("#my-id");
    assertTag("div", result);
    assertAttrs(["id" => "my-id"], result);
  }

  public function testParseSelectorClasses() {
    var result = SelectorParser.parseSelector(".fa.fa-arrow-right");
    assertTag("div", result);
    assertAttrs(["class" => "fa fa-arrow-right"], result);
  }

  public function testParseSelectorAttributeString() {
    var result = SelectorParser.parseSelector("[data-my-thing=test]");
    assertTag("div", result);
    assertAttrs(["data-my-thing" => "test"], result);
  }

  public function testParseSelectorAttributeBool() {
    var result = SelectorParser.parseSelector("[disabled=true]");
    assertTag("div", result);
    assertAttrs(["disabled" => true], result);
  }

  public function testAll() {
    var result = SelectorParser.parseSelector("button#my-button.btn.btn-primary.btn-lg[data-scope=test][disabled=true].another-class");
    assertTag("button", result);
    assertAttrs([
      "id" => "my-button",
      "class" => "btn btn-primary btn-lg another-class",
      "data-scope" => "test",
      "disabled" => true,
    ], result);

  }

  inline function assertTag(expectedTag : String, actual : SelectorParserResult) : Void {
    Assert.same(expectedTag, actual.tag);
  }

  inline function assertNoAttrs(actual : SelectorParserResult) : Void {
    Assert.same(0, actual.attributes.keys().toArray().length);
  }

  inline function assertAttrs(expected : Map<String, AttributeValue>, actual : SelectorParserResult) : Void {
    Assert.same(expected.keys().toArray().length, actual.attributes.keys().toArray().length);
    for (key in expected.keys()) {
      var expectedValue = expected.get(key);
      var actualValue = actual.attributes.get(key);
      Assert.isTrue(expectedValue.equalsTo(actualValue));
    }
  }
}
