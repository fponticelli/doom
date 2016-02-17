package doom.html;

import js.Browser.*;
import utest.Assert;
import doom.core.VNode;
import dots.Html;
import doom.html.Html.*;

class TestRender {
  var render : Render;
  public function new() {}

  public function setup() {
    document.body.innerHTML = "";
    render = new Render();
  }

  public function testGenerate() {
    var tests = [
      { value : Comment("a comment"), expected : "<!--a comment-->" },
      { value : Text("text node"), expected : "text node" },
      { value : Element("div", ["class" => "container"], [
        Element("h1", new Map(), [Text("title")]),
        Element("h2", new Map(), [Text("subtitle")]),
      ]), expected : '<div class="container"><h1>title</h1><h2>subtitle</h2></div>'}
    ];
    for(test in tests)
      Assert.equals(test.expected, Html.toString(render.generate(test.value)));
  }

  public function testSettingAttributes() {
    var div = document.createElement("div");
    div.setAttribute("id", "main");
    render.applyNodeAttributes(["class" => "container"], div);
    Assert.equals("container", div.getAttribute("class"));
    Assert.isFalse(div.hasAttribute("id"));
  }

  public function testMountElement() {
    render.mount(div(["class" => "some"]), document.body);
    Assert.equals('<div class="some"></div>', document.body.innerHTML);
  }

  public function testApplyText2Text() {
    render.mount(text("hello"), document.body);
    Assert.equals('hello', document.body.innerHTML);
    render.apply(text("ciao"), document.body.firstChild);
    Assert.equals('ciao', document.body.innerHTML);
  }

  public function testApplyText2Comment() {
    render.mount(comment("hello"), document.body);
    Assert.equals('<!--hello-->', document.body.innerHTML);
    render.apply(text("ciao"), document.body.firstChild);
    Assert.equals('ciao', document.body.innerHTML);
  }

  public function testApplyText2Element() {
    render.mount(div(), document.body);
    Assert.equals('<div></div>', document.body.innerHTML);
    render.apply(text("ciao"), document.body.firstChild);
    Assert.equals('ciao', document.body.innerHTML);
  }

  public function testApplyText2Raw() {

    // render.apply(text("ciao"), document.body.firstChild);
    // Assert.equals('ciao', document.body.innerHTML);
  }

  public function testApplyText2Component() {

    // render.apply(text("ciao"), document.body.firstChild);
    // Assert.equals('ciao', document.body.innerHTML);
  }

  public function testApplyComment2Comment() {
    render.mount(comment("hello"), document.body);
    Assert.equals('<!--hello-->', document.body.innerHTML);
    render.apply(comment("ciao"), document.body.firstChild);
    Assert.equals('<!--ciao-->', document.body.innerHTML);
  }

  public function testApplyComment2Text() {
  }

  public function testApplyComment2Raw() {
  }

  public function testApplyComment2Element() {
  }

  public function testApplyComment2Component() {
  }

  public function testApplyElement2ElementSameTag() {

  }

  public function testApplyElement2ElementDifferentTag() {

  }

  public function testApplyElement2Text() {

  }

  public function testApplyElement2Comment() {

  }

  public function testApplyElement2Raw() {

  }

  public function testApplyElement2Component() {

  }

  // text, comment, raw, element, component
  // text area
}
