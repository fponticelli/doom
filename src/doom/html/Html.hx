package doom.html;

import doom.core.*;

class Html {
  inline public static function a(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("a", attributes, children);
  inline public static function abbr(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("abbr", attributes, children);
  inline public static function address(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("address", attributes, children);
  inline public static function area(?attributes : Map<String, AttributeValue>)
    return el("area", attributes);
  inline public static function article(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("article", attributes, children);
  inline public static function aside(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("aside", attributes, children);
  inline public static function audio(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("audio", attributes, children);
  inline public static function b(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("b", attributes, children);
  inline public static function base(?attributes : Map<String, AttributeValue>)
    return el("base", attributes);
  inline public static function bdi(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("bdi", attributes, children);
  inline public static function bdo(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("bdo", attributes, children);
  inline public static function blockquote(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("blockquote", attributes, children);
  inline public static function body(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("body", attributes, children);
  inline public static function br(?attributes : Map<String, AttributeValue>)
    return el("br", attributes);
  inline public static function button(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("button", attributes, children);
  inline public static function canvas(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("canvas", attributes, children);
  inline public static function caption(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("caption", attributes, children);
  inline public static function cite(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("cite", attributes, children);
  inline public static function code(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("code", attributes, children);
  inline public static function col(?attributes : Map<String, AttributeValue>)
    return el("col", attributes);
  inline public static function colgroup(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("colgroup", attributes, children);
  inline public static function data(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("data", attributes, children);
  inline public static function datalist(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("datalist", attributes, children);
  inline public static function dd(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("dd", attributes, children);
  inline public static function del(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("del", attributes, children);
  inline public static function details(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("details", attributes, children);
  inline public static function dfn(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("dfn", attributes, children);
  inline public static function dialog(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("dialog", attributes, children);
  inline public static function div(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("div", attributes, children);
  inline public static function dl(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("dl", attributes, children);
  inline public static function dt(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("dt", attributes, children);
  inline public static function em(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("em", attributes, children);
  inline public static function embed(?attributes : Map<String, AttributeValue>)
    return el("embed", attributes);
  inline public static function fieldset(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("fieldset", attributes, children);
  inline public static function figcaption(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("figcaption", attributes, children);
  inline public static function figure(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("figure", attributes, children);
  inline public static function footer(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("footer", attributes, children);
  inline public static function form(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("form", attributes, children);
  inline public static function h1(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("h1", attributes, children);
  inline public static function h2(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("h2", attributes, children);
  inline public static function h3(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("h3", attributes, children);
  inline public static function h4(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("h4", attributes, children);
  inline public static function h5(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("h5", attributes, children);
  inline public static function h6(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("h6", attributes, children);
  inline public static function head(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("head", attributes, children);
  inline public static function header(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("header", attributes, children);
  inline public static function hgroup(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("hgroup", attributes, children);
  inline public static function hr(?attributes : Map<String, AttributeValue>)
    return el("hr", attributes);
  inline public static function html(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("html", attributes, children);
  inline public static function i(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("i", attributes, children);
  inline public static function iframe(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("iframe", attributes, children);
  inline public static function img(?attributes : Map<String, AttributeValue>)
    return el("img", attributes);
  inline public static function input(?attributes : Map<String, AttributeValue>)
    return el("input", attributes);
  inline public static function ins(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("ins", attributes, children);
  inline public static function kbd(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("kbd", attributes, children);
  inline public static function keygen(?attributes : Map<String, AttributeValue>)
    return el("keygen", attributes);
  inline public static function label(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("label", attributes, children);
  inline public static function legend(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("legend", attributes, children);
  inline public static function li(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("li", attributes, children);
  inline public static function link(?attributes : Map<String, AttributeValue>)
    return el("link", attributes);
  inline public static function main(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("main", attributes, children);
  inline public static function map(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("map", attributes, children);
  inline public static function mark(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("mark", attributes, children);
  inline public static function menu(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("menu", attributes, children);
  inline public static function menuitem(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("menuitem", attributes, children);
  inline public static function meta(?attributes : Map<String, AttributeValue>)
    return el("meta", attributes);
  inline public static function meter(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("meter", attributes, children);
  inline public static function nav(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("nav", attributes, children);
  inline public static function noscript(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("noscript", attributes, children);
  inline public static function object(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("object", attributes, children);
  inline public static function ol(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("ol", attributes, children);
  inline public static function optgroup(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("optgroup", attributes, children);
  inline public static function option(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("option", attributes, children);
  inline public static function output(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("output", attributes, children);
  inline public static function p(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("p", attributes, children);
  inline public static function param(?attributes : Map<String, AttributeValue>)
    return el("param", attributes);
  inline public static function pre(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("pre", attributes, children);
  inline public static function progress(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("progress", attributes, children);
  inline public static function q(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("q", attributes, children);
  inline public static function rb(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("rb", attributes, children);
  inline public static function rp(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("rp", attributes, children);
  inline public static function rt(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("rt", attributes, children);
  inline public static function rtc(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("rtc", attributes, children);
  inline public static function ruby(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("ruby", attributes, children);
  inline public static function s(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("s", attributes, children);
  inline public static function samp(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("samp", attributes, children);
  inline public static function script(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("script", attributes, children);
  inline public static function section(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("section", attributes, children);
  inline public static function select(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("select", attributes, children);
  inline public static function small(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("small", attributes, children);
  inline public static function source(?attributes : Map<String, AttributeValue>)
    return el("source", attributes);
  inline public static function span(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("span", attributes, children);
  inline public static function strong(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("strong", attributes, children);
  inline public static function style(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("style", attributes, children);
  inline public static function sub(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("sub", attributes, children);
  inline public static function summary(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("summary", attributes, children);
  inline public static function sup(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("sup", attributes, children);
  inline public static function table(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("table", attributes, children);
  inline public static function tbody(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("tbody", attributes, children);
  inline public static function td(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("td", attributes, children);
  inline public static function template(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("template", attributes, children);
  inline public static function textarea(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("textarea", attributes, children);
  inline public static function tfoot(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("tfoot", attributes, children);
  inline public static function th(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("th", attributes, children);
  inline public static function thead(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("thead", attributes, children);
  inline public static function time(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("time", attributes, children);
  inline public static function title(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("title", attributes, children);
  inline public static function tr(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("tr", attributes, children);
  inline public static function track(?attributes : Map<String, AttributeValue>)
    return el("track", attributes);
  inline public static function u(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("u", attributes, children);
  inline public static function ul(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("ul", attributes, children);
  inline public static function htmlvar(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("var", attributes, children);
  inline public static function video(?attributes : Map<String, AttributeValue>, ?children : VNodes)
    return el("video", attributes, children);
  inline public static function wbr(?attributes : Map<String, AttributeValue>)
    return el("wbr", attributes);

  // TODO: make this a macro that can parse at compile time if the string is available at compile time,
  // or falls back to runtime if the string is not available at compile time
  inline public static function D(selector : String, ?attributes : Map<String, AttributeValue>, ?children : VNodes) : VNode {
    var parseResult = SelectorParser.parseSelector(selector, attributes);
    return el(parseResult.tag, parseResult.attributes, children);
  }

  inline public static function el(name : String,
    ?attributes : Map<String, AttributeValue>,
    ?children : VNodes) : VNode
    return VNode.el(name, attributes, children);

  inline public static function text(content : String) : VNode
    return VNode.text(content);

  inline public static function raw(content : String) : VNode
    return VNode.raw(content);

  inline public static function dummy(?text : String = "empty node") : VNode
    return VNode.el("div", [
      "style" => "display:none",
      "data-comment" => text
    ]);

  inline public static function comp<Props, El>(comp : Component<Props, El>) : VNode
    return VNode.comp(comp);
}
