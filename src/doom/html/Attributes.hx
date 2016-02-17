package doom.html;

import js.html.Element;

class Attributes {
  public static function getAttribute(el : Element, name : String) {
    var prop = properties.get(name);
    return switch prop {
      case null, BooleanAttribute, OverloadedBooleanAttribute, NumericAttribute, PositiveNumericAttribute:
        el.getAttribute(name);
      case Property, BooleanProperty, SideEffectProperty:
        Reflect.field(el, name);
    };
  }

  public static function setDynamicAttribute(el : Element, name : String, value : Dynamic) {
    var prop = properties.get(name);
    return switch prop {
      case null, BooleanAttribute, OverloadedBooleanAttribute, NumericAttribute, PositiveNumericAttribute:
        el.setAttribute(name, value);
      case Property, BooleanProperty, SideEffectProperty:
        Reflect.setField(el, name, value);
    };
  }

  public static function setStringAttribute(el : Element, name : String, value : String) {
    var prop = properties.get(name);
    return switch prop {
      case null, BooleanAttribute, OverloadedBooleanAttribute, NumericAttribute, PositiveNumericAttribute:
        el.setAttribute(name, value);
      case Property, BooleanProperty, SideEffectProperty:
        Reflect.setField(el, name, value);
    };
  }

  public static function toggleBoolAttribute(el : Element, name : String, value : Bool) {
    var prop = properties.get(name);
    return switch prop {
      case null, BooleanAttribute, OverloadedBooleanAttribute, NumericAttribute, PositiveNumericAttribute:
        if(value)
          el.setAttribute(name, name);
        else
          el.removeAttribute(name);
      case Property, BooleanProperty, SideEffectProperty:
        Reflect.setField(el, name, value);
    };
  }

  public static function removeAttribute(el : Element, name : String) {
    el.removeAttribute(name);
  }

  public static var properties(default, null) : Map<String, AttributeType> = [
    // ** Standard Properties
    //"accept" => null,
    //"acceptCharset" => null,
    //"accessKey" => null,
    //"action" => null,
    "allowFullScreen" => BooleanAttribute,
    //"allowTransparency" => null,
    //"alt" => null,
    "async" => BooleanAttribute,
    //"autoComplete" => null,
    "autoFocus" => BooleanAttribute,
    "autoPlay" => BooleanAttribute,
    "capture" => BooleanAttribute,
    //"cellPadding" => null,
    //"cellSpacing" => null,
    //"charSet" => null,
    //"challenge" => null,
    "checked" => BooleanProperty,
    //"classID" => null,
    //"className" => null,
    "cols" => PositiveNumericAttribute,
    //"colSpan" => null,
    //"content" => null,
    //"contentEditable" => null,
    //"contextMenu" => null,
    "controls" => BooleanAttribute,
    //"coords" => null,
    //"crossOrigin" => null,
    //"data" => null, // For `<object />` acts as `src`.
    //"dateTime" => null,
    "default" => BooleanAttribute,
    "defer" => BooleanAttribute,
    //"dir" => null,
    "disabled" => BooleanAttribute,
    "download" => OverloadedBooleanAttribute,
    //"draggable" => null,
    //"encType" => null,
    //"form" => null,
    //"formAction" => null,
    //"formEncType" => null,
    //"formMethod" => null,
    "formNoValidate" => BooleanAttribute,
    //"formTarget" => null,
    //"frameBorder" => null,
    //"headers" => null,
    //"height" => null,
    "hidden" => BooleanAttribute,
    //"high" => null,
    //"href" => null,
    //"hrefLang" => null,
    //"htmlFor" => null,
    //"httpEquiv" => null,
    //"icon" => null,
    //"id" => null,
    //"inputMode" => null,
    //"integrity" => null,
    //"is" => null,
    //"keyParams" => null,
    //"keyType" => null,
    //"kind" => null,
    //"label" => null,
    //"lang" => null,
    //"list" => null,
    "loop" => BooleanAttribute,
    //"low" => null,
    //"manifest" => null,
    //"marginHeight" => null,
    //"marginWidth" => null,
    //"max" => null,
    //"maxLength" => null,
    //"media" => null,
    //"mediaGroup" => null,
    //"method" => null,
    //"min" => null,
    //"minLength" => null,
    // Caution; `option.selected` is not updated if `select.multiple` is
    // disabled with `removeAttribute`.
    "multiple" => BooleanProperty,
    "muted" => BooleanProperty,
    //"name" => null,
    //"nonce" => null,
    "noValidate" => BooleanAttribute,
    "open" => BooleanAttribute,
    //"optimum" => null,
    //"pattern" => null,
    //"placeholder" => null,
    //"poster" => null,
    //"preload" => null,
    //"profile" => null,
    //"radioGroup" => null,
    "readOnly" => BooleanAttribute,
    //"rel" => null,
    "required" => BooleanAttribute,
    "reversed" => BooleanAttribute,
    //"role" => null,
    "rows" => PositiveNumericAttribute,
    "rowSpan" => NumericAttribute,
    //"sandbox" => null,
    //"scope" => null,
    "scoped" => BooleanAttribute,
    //"scrolling" => null,
    "seamless" => BooleanAttribute,
    "selected" => BooleanProperty,
    //"shape" => null,
    "size" => PositiveNumericAttribute,
    //"sizes" => null,
    "span" => PositiveNumericAttribute,
    //"spellCheck" => null,
    //"src" => null,
    //"srcDoc" => null,
    //"srcLang" => null,
    //"srcSet" => null,
    "start" => NumericAttribute,
    //"step" => null,
    //"style" => null,
    //"summary" => null,
    //"tabIndex" => null,
    //"target" => null,
    //"title" => null,
    // Setting .type throws on non-<input> tags
    //"type" => null,
    //"useMap" => null,
    "value" => SideEffectProperty,
    //"width" => null,
    //"wmode" => null,
    //"wrap" => null,

    // ** RDFa Properties
    //"about" => null,
    //"datatype" => null,
    //"inlist" => null,
    //"prefix" => null,
    // property is also supported for OpenGraph in meta tags.
    //"property" => null,
    //"resource" => null,
    //"typeof" => null,
    //"vocab" => null,

    // ** Non-standard Properties
    // autoCapitalize and autoCorrect are supported in Mobile Safari for
    // keyboard hints.
    //"autoCapitalize" => null,
    //"autoCorrect" => null,
    // autoSave allows WebKit/Blink to persist values of input fields on page reloads
    //"autoSave" => null,
    // color is for Safari mask-icon link
    //"color" => null,
    // itemProp, itemScope, itemType are for
    // Microdata support. See http://schema.org/docs/gs.html
    //"itemProp" => null,
    "itemScope" => BooleanAttribute,
    //"itemType" => null,
    // itemID and itemRef are for Microdata support as well but
    // only specified in the WHATWG spec document. See
    // https://html.spec.whatwg.org/multipage/microdata.html#microdata-dom-api
    //"itemID" => null,
    //"itemRef" => null,
    // results show looking glass icon and recent searches on input
    // search fields in WebKit/Blink
    //"results" => null,
    // IE-only attribute that specifies security restrictions on an iframe
    // as an alternative to the sandbox attribute on IE<10
    //"security" => null,
    // IE-only attribute that controls focus behavior
    //"unselectable" => null,
  ];
}

enum AttributeType {
  BooleanAttribute;
  Property;
  BooleanProperty;
  OverloadedBooleanAttribute;
  NumericAttribute;
  PositiveNumericAttribute;
  SideEffectProperty;
}
