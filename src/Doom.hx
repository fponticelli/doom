import doom.AttributeValue;
import doom.Component;
import doom.IComponent;
import doom.Node;
import js.html.Element;

@:autoBuild(doom.macro.AutoComponentBuild.build())
class Doom extends doom.ComponentBase {
  public static function mount(component : IComponent, ref : Element) {
    if(null == ref)
      throw 'reference element is set to null';
    ref.innerHTML = "";
    component.init();
    ref.appendChild(component.element);
    thx.Timer.immediate(component.didMount);
  }

  // namespaces
  public static var namespaces = [
    "svg" => "http://www.w3.org/2000/svg"
  ];

  // HTML HELPERS
  inline public static function a(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("a", attributes, children, child);
  inline public static function abbr(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("abbr", attributes, children, child);
  inline public static function address(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("address", attributes, children, child);
  inline public static function area(?attributes : Map<String, AttributeValue>)
    return el("area", attributes);
  inline public static function article(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("article", attributes, children, child);
  inline public static function aside(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("aside", attributes, children, child);
  inline public static function audio(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("audio", attributes, children, child);
  inline public static function b(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("b", attributes, children, child);
  inline public static function base(?attributes : Map<String, AttributeValue>)
    return el("base", attributes);
  inline public static function bdi(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("bdi", attributes, children, child);
  inline public static function bdo(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("bdo", attributes, children, child);
  inline public static function blockquote(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("blockquote", attributes, children, child);
  inline public static function body(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("body", attributes, children, child);
  inline public static function br(?attributes : Map<String, AttributeValue>)
    return el("br", attributes);
  inline public static function button(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("button", attributes, children, child);
  inline public static function canvas(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("canvas", attributes, children, child);
  inline public static function caption(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("caption", attributes, children, child);
  inline public static function cite(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("cite", attributes, children, child);
  inline public static function code(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("code", attributes, children, child);
  inline public static function col(?attributes : Map<String, AttributeValue>)
    return el("col", attributes);
  inline public static function colgroup(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("colgroup", attributes, children, child);
  inline public static function data(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("data", attributes, children, child);
  inline public static function datalist(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("datalist", attributes, children, child);
  inline public static function dd(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("dd", attributes, children, child);
  inline public static function del(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("del", attributes, children, child);
  inline public static function details(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("details", attributes, children, child);
  inline public static function dfn(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("dfn", attributes, children, child);
  inline public static function dialog(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("dialog", attributes, children, child);
  inline public static function div(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("div", attributes, children, child);
  inline public static function dl(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("dl", attributes, children, child);
  inline public static function dt(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("dt", attributes, children, child);
  inline public static function em(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("em", attributes, children, child);
  inline public static function embed(?attributes : Map<String, AttributeValue>)
    return el("embed", attributes);
  inline public static function fieldset(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("fieldset", attributes, children, child);
  inline public static function figcaption(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("figcaption", attributes, children, child);
  inline public static function figure(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("figure", attributes, children, child);
  inline public static function footer(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("footer", attributes, children, child);
  inline public static function form(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("form", attributes, children, child);
  inline public static function h1(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("h1", attributes, children, child);
  inline public static function h2(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("h2", attributes, children, child);
  inline public static function h3(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("h3", attributes, children, child);
  inline public static function h4(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("h4", attributes, children, child);
  inline public static function h5(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("h5", attributes, children, child);
  inline public static function h6(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("h6", attributes, children, child);
  inline public static function head(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("head", attributes, children, child);
  inline public static function header(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("header", attributes, children, child);
  inline public static function hgroup(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("hgroup", attributes, children, child);
  inline public static function hr(?attributes : Map<String, AttributeValue>)
    return el("hr", attributes);
  inline public static function html(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("html", attributes, children, child);
  inline public static function i(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("i", attributes, children, child);
  inline public static function iframe(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("iframe", attributes, children, child);
  inline public static function img(?attributes : Map<String, AttributeValue>)
    return el("img", attributes);
  inline public static function input(?attributes : Map<String, AttributeValue>)
    return el("input", attributes);
  inline public static function ins(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("ins", attributes, children, child);
  inline public static function kbd(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("kbd", attributes, children, child);
  inline public static function keygen(?attributes : Map<String, AttributeValue>)
    return el("keygen", attributes);
  inline public static function label(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("label", attributes, children, child);
  inline public static function legend(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("legend", attributes, children, child);
  inline public static function li(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("li", attributes, children, child);
  inline public static function link(?attributes : Map<String, AttributeValue>)
    return el("link", attributes);
  inline public static function main(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("main", attributes, children, child);
  inline public static function map(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("map", attributes, children, child);
  inline public static function mark(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("mark", attributes, children, child);
  inline public static function menu(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("menu", attributes, children, child);
  inline public static function menuitem(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("menuitem", attributes, children, child);
  inline public static function meta(?attributes : Map<String, AttributeValue>)
    return el("meta", attributes);
  inline public static function meter(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("meter", attributes, children, child);
  inline public static function nav(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("nav", attributes, children, child);
  inline public static function noscript(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("noscript", attributes, children, child);
  inline public static function object(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("object", attributes, children, child);
  inline public static function ol(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("ol", attributes, children, child);
  inline public static function optgroup(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("optgroup", attributes, children, child);
  inline public static function option(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("option", attributes, children, child);
  inline public static function output(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("output", attributes, children, child);
  inline public static function p(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("p", attributes, children, child);
  inline public static function param(?attributes : Map<String, AttributeValue>)
    return el("param", attributes);
  inline public static function pre(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("pre", attributes, children, child);
  inline public static function progress(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("progress", attributes, children, child);
  inline public static function q(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("q", attributes, children, child);
  inline public static function rb(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("rb", attributes, children, child);
  inline public static function rp(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("rp", attributes, children, child);
  inline public static function rt(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("rt", attributes, children, child);
  inline public static function rtc(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("rtc", attributes, children, child);
  inline public static function ruby(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("ruby", attributes, children, child);
  inline public static function s(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("s", attributes, children, child);
  inline public static function samp(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("samp", attributes, children, child);
  inline public static function script(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("script", attributes, children, child);
  inline public static function section(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("section", attributes, children, child);
  inline public static function select(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("select", attributes, children, child);
  inline public static function small(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("small", attributes, children, child);
  inline public static function source(?attributes : Map<String, AttributeValue>)
    return el("source", attributes);
  inline public static function span(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("span", attributes, children, child);
  inline public static function strong(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("strong", attributes, children, child);
  inline public static function style(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("style", attributes, children, child);
  inline public static function sub(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("sub", attributes, children, child);
  inline public static function summary(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("summary", attributes, children, child);
  inline public static function sup(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("sup", attributes, children, child);
  inline public static function table(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("table", attributes, children, child);
  inline public static function tbody(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("tbody", attributes, children, child);
  inline public static function td(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("td", attributes, children, child);
  inline public static function template(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("template", attributes, children, child);
  inline public static function textarea(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("textarea", attributes, children, child);
  inline public static function tfoot(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("tfoot", attributes, children, child);
  inline public static function th(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("th", attributes, children, child);
  inline public static function thead(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("thead", attributes, children, child);
  inline public static function time(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("time", attributes, children, child);
  inline public static function title(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("title", attributes, children, child);
  inline public static function tr(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("tr", attributes, children, child);
  inline public static function track(?attributes : Map<String, AttributeValue>)
    return el("track", attributes);
  inline public static function u(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("u", attributes, children, child);
  inline public static function ul(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("ul", attributes, children, child);
  inline public static function htmlvar(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("var", attributes, children, child);
  inline public static function video(?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node)
    return el("video", attributes, children, child);
  inline public static function wbr(?attributes : Map<String, AttributeValue>)
    return el("wbr", attributes);

  // TODO: make this a macro that can parse at compile time if the string is available at compile time,
  // or falls back to runtime if the string is not available at compile time
  inline public static function D(selector : String, ?attributes : Map<String, AttributeValue>, ?children : Array<Node>, ?child : Node) : Node {
    var parseResult = doom.SelectorParser.parseSelector(selector, attributes);
    return el(parseResult.tag, parseResult.attributes, children, child);
  }

  inline public static function el(name : String,
    ?attributes : Map<String, AttributeValue>,
    ?children : Array<Node>,
    ?child : Node) : Node
    return Node.el(name, attributes, children, child);

  inline public static function text(content : String) : Node
    return Node.text(content);

  inline public static function raw(content : String) : Node
    return Node.raw(content);

  inline public static function dummy(?text : String = "empty node") : Node
    return Node.el("div", [
      "style" => "display:none",
      "data-comment" => text
    ]);

  inline public static function comp(comp : IComponent) : Node
    return Node.comp(comp);

}
