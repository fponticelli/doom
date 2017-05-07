package doom.core;

import thx.Error;
using thx.Arrays;
using thx.Iterators;
using thx.Bools;

typedef SelectorParserResult = {
  tag : String,
  attributes : Map<String, AttributeValue>,
};

class SelectorParser {
  var selector : String;
  var index : Int;

  public static function parseSelector(selector : String, ?otherAttributes : Map<String, AttributeValue>) : SelectorParserResult {
    var result = new SelectorParser(selector).parse();
    if (otherAttributes != null) {
      result.attributes = mergeAttributes(result.attributes, otherAttributes);
    }
    return result;
  }

  function new(selector : String) {
    this.selector = selector;
    this.index = 0;
  }

  static function mergeAttributes(dest : Map<String, AttributeValue>, other : Map<String, AttributeValue>) : Map<String, AttributeValue> {
    return other.keys().reduce(function(acc : Map<String, AttributeValue>, key) {
      var value = other.get(key);

      // special case: concatenate class strings (
      if (key == "class" && acc.exists(key)) {
        var previousValue = acc.get(key);
        value = '${previousValue.toString()} ${value.toString()}';
      }

      acc.set(key, value);
      return acc;
    }, dest);
  }

  function parse() : SelectorParserResult {
    var tag = gobbleTag();
    var attributes = gobbleAttributes();
    return {
      tag: tag,
      attributes: attributes,
    };
  }

  function gobbleTag() : String {
    return isIdentifierStart() ? gobbleIdentifier() : "div";
  }

  function gobbleAttributes() : Map<String, AttributeValue> {
    var attributes : Map<String, AttributeValue> = new Map();
    while (index < selector.length) {
      var attribute = gobbleAttribute();
      // trace(attribute.key, attribute.value);
      if (attribute.key == "class" && attributes.exists("class")) {
        var previousClass = attributes.get("class").toString();
        attribute.value = '$previousClass ${attribute.value.toString()}';
      }
      // trace(attribute.key, attribute.value);
      attributes.set(attribute.key, attribute.value);
    }
    return attributes;
  }

  function gobbleAttribute() : { key : String, value : AttributeValue } {
    return switch char() {
      case "#": gobbleElementId();
      case ".": gobbleElementClass();
      case "[": gobbleElementAttribute();
      case unknown: throw new Error('unknown selector char "$unknown" at pos $index');
    };
  }

  function gobbleElementId() : { key: String, value: AttributeValue } {
    gobbleChar("#");
    var id = gobbleIdentifier();
    return { key: "id", value: id };
  }

  function gobbleElementClass() : { key: String, value: AttributeValue } {
    gobbleChar(".");
    var id = gobbleIdentifier();
    return { key: "class", value: id };
  }

  function gobbleElementAttribute() : { key: String, value: AttributeValue } {
    gobbleChar("["); // [
    var key = gobbleIdentifier();
    gobbleChar("=");
    var value : AttributeValue = gobbleUpTo("]");
    if (Bools.canParse(value.toString())) {
      value = Bools.parse(value.toString());
    }
    gobbleChar("]");
    return { key : key, value : value };
  }

  function gobbleIdentifier() : String {
    var result : Array<String> = [];
    result.push(gobbleChar());
    while (isIdentifierPart()) {
      result.push(gobbleChar());
    }
    return result.join("");
  }

  function gobbleChar(?expecting : String, ?expectingAnyOf: Array<String>) : String {
    var c = selector.charAt(index++);
    if (expecting != null && expecting != c) {
      throw new Error('expecting $expecting at position $index of $selector');
    }
    if (expectingAnyOf != null && !expectingAnyOf.contains(c)) {
      throw new Error('expecting one of ${expectingAnyOf.join(", ")} at position $index of $selector');
    }
    return c;
  }

  function gobbleUpTo(stopChar : String) : String {
    var result : Array<String> = [];
    while (char() != stopChar) {
      result.push(gobbleChar());
    }
    return result.join("");
  }

  function isAlpha() : Bool {
    var c = code();
    return (c >= 65 && c <= 90) || (c >= 97 && c <= 122);
  }

  function isNumeric() : Bool {
    var c = code();
    return (c >= 48 && c <= 57);
  }

  function isAlphaNumeric() {
    return isAlpha() || isNumeric();
  }

  function isAny(cs : Array<String>) : Bool {
    for (c in cs) {
      if (c == char()) return true;
    }
    return false;
  }

  function isIdentifierStart() : Bool {
    return isAlpha();
  }

  function isIdentifierPart() : Bool {
    return isAlpha() || isNumeric() || isAny(["_", "-"]); // don't allow : or . as identifiers, as this can mess up things like ".fa.fa-arrow-right"
  }

  function isIdStart() : Bool {
    return char() == "#";
  }

  function isClassStart() : Bool {
    return char() == ".";
  }

  function char() : String {
    return selector.charAt(index);
  }

  function code() : Int {
    return selector.charCodeAt(index);
  }
}
