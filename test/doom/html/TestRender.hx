package doom.html;

import utest.Assert;
import doom.core.VNode;
import dots.Html;

class TestRender {
  var renderer : Render;
  public function new() {}

  public function setup() {
    renderer = new Render();
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
      Assert.equals(test.expected, Html.toString(renderer.generate(test.value)));
  }

  public function testSettingAttributes() {
    var div = js.Browser.document.createElement("div");
    div.setAttribute("id", "main");
    renderer.updateAttributes(["class" => "container"], div);
    Assert.equals("container", div.getAttribute("class"));
    Assert.isFalse(div.hasAttribute("id"));
  }
}
