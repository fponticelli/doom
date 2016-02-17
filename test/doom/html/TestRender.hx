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
    while(document.body.childNodes.length > 0)
      document.body.removeChild(document.body.childNodes[0]);
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
    render.mount(raw("<div>hello</div>"), document.body);
    Assert.equals('<div>hello</div>', document.body.innerHTML);
    render.apply(text("ciao"), document.body.firstChild);
    Assert.equals('ciao', document.body.innerHTML);
  }

  public function testApplyText2Component() {
    render.mount(comp(new SampleComponent({}, [])), document.body);
    Assert.equals('<span>component</span>', document.body.innerHTML);
    render.apply(text("ciao"), document.body.firstChild);
    Assert.equals('ciao', document.body.innerHTML);
  }

  public function testApplyComment2Comment() {
    render.mount(comment("hello"), document.body);
    Assert.equals('<!--hello-->', document.body.innerHTML);
    render.apply(comment("ciao"), document.body.firstChild);
    Assert.equals('<!--ciao-->', document.body.innerHTML);
  }

  public function testApplyComment2Text() {
    render.mount(text("hello"), document.body);
    Assert.equals('hello', document.body.innerHTML);
    render.apply(comment("ciao"), document.body.firstChild);
    Assert.equals('<!--ciao-->', document.body.innerHTML);
  }

  public function testApplyComment2Raw() {
    render.mount(raw("<div>hello</div>"), document.body);
    Assert.equals('<div>hello</div>', document.body.innerHTML);
    render.apply(comment("ciao"), document.body.firstChild);
    Assert.equals('<!--ciao-->', document.body.innerHTML);
  }

  public function testApplyComment2Element() {
    render.mount(div("hello"), document.body);
    Assert.equals('<div>hello</div>', document.body.innerHTML);
    render.apply(comment("ciao"), document.body.firstChild);
    Assert.equals('<!--ciao-->', document.body.innerHTML);
  }

  public function testApplyComment2Component() {
    render.mount(comp(new SampleComponent({}, [])), document.body);
    Assert.equals('<span>component</span>', document.body.innerHTML);
    render.apply(comment("ciao"), document.body.firstChild);
    Assert.equals('<!--ciao-->', document.body.innerHTML);
  }

  public function testApplyElement2ElementSameTag() {
    render.mount(div("ciao"), document.body);
    Assert.equals('<div>ciao</div>', document.body.innerHTML);
    render.apply(div("hello"), document.body.firstChild);
    Assert.equals('<div>hello</div>', document.body.innerHTML);
  }

  public function testApplyElement2ElementSameTagDifferentAttributes() {
    render.mount(div(["class" => "some"], "ciao"), document.body);
    Assert.equals('<div class="some">ciao</div>', document.body.innerHTML);
    render.apply(div(["id" => "main"], "hello"), document.body.firstChild);
    Assert.equals('<div id="main">hello</div>', document.body.innerHTML);
  }

  public function testApplyElement2ElementDifferentTag() {
    render.mount(div("ciao"), document.body);
    Assert.equals('<div>ciao</div>', document.body.innerHTML);
    render.apply(span("hello"), document.body.firstChild);
    Assert.equals('<span>hello</span>', document.body.innerHTML);
  }

  public function testApplyElement2Text() {
    render.mount(text("ciao"), document.body);
    Assert.equals('ciao', document.body.innerHTML);
    render.apply(div("hello"), document.body.firstChild);
    Assert.equals('<div>hello</div>', document.body.innerHTML);
  }

  public function testApplyElement2Comment() {
    render.mount(comment("ciao"), document.body);
    Assert.equals('<!--ciao-->', document.body.innerHTML);
    render.apply(div("hello"), document.body.firstChild);
    Assert.equals('<div>hello</div>', document.body.innerHTML);
  }

  public function testApplyElement2Raw() {
    render.mount(raw("<div>hello</div>"), document.body);
    Assert.equals('<div>hello</div>', document.body.innerHTML);
    render.apply(div("ciao"), document.body.firstChild);
    Assert.equals('<div>ciao</div>', document.body.innerHTML);
  }

  public function testApplyElement2RawDifferentElement() {
    render.mount(raw("<div>hello</div>"), document.body);
    Assert.equals('<div>hello</div>', document.body.innerHTML);
    render.apply(span("ciao"), document.body.firstChild);
    Assert.equals('<span>ciao</span>', document.body.innerHTML);
  }

  public function testApplyElement2Component() {
    render.mount(comp(new SampleComponent({}, [])), document.body);
    Assert.equals('<span>component</span>', document.body.innerHTML);
    render.apply(div("ciao"), document.body.firstChild);
    Assert.equals('<div>ciao</div>', document.body.innerHTML);
  }

  public function testApplyRaw2Component() {
    render.mount(comp(new SampleComponent({}, [])), document.body);
    Assert.equals('<span>component</span>', document.body.innerHTML);
    render.apply(raw("<div>hello</div>"), document.body.firstChild);
    Assert.equals('<div>hello</div>', document.body.innerHTML);
  }

  public function testApplyRaw2ElementSameTag() {
    render.mount(div("hello"), document.body);
    Assert.equals('<div>hello</div>', document.body.innerHTML);
    render.apply(raw("<div>ciao</div>"), document.body.firstChild);
    Assert.equals('<div>ciao</div>', document.body.innerHTML);
  }

  public function testApplyRaw2ElementDifferentTag() {
    render.mount(div("hello"), document.body);
    Assert.equals('<div>hello</div>', document.body.innerHTML);
    render.apply(raw("<span>ciao</span>"), document.body.firstChild);
    Assert.equals('<span>ciao</span>', document.body.innerHTML);
  }

  public function testApplyRaw2Comment() {
    render.mount(comment("ciao"), document.body);
    Assert.equals('<!--ciao-->', document.body.innerHTML);
    render.apply(raw("<span>hello</span>"), document.body.firstChild);
    Assert.equals('<span>hello</span>', document.body.innerHTML);
  }

  public function testApplyRaw2Text() {
    render.mount(text("ciao"), document.body);
    Assert.equals('ciao', document.body.innerHTML);
    render.apply(raw("<span>hello</span>"), document.body.firstChild);
    Assert.equals('<span>hello</span>', document.body.innerHTML);
  }

  public function testApplyMultiRaw2Element() {
    render.mount(div("ciao"), document.body);
    render.apply(raw("<script>olà</script><span>hello</span>"), document.body.firstChild);
    Assert.equals('<script>olà</script><span>hello</span>', document.body.innerHTML);
  }
}

private class SampleComponent extends doom.html.Component<{}> {
  override function render() {
    return span("component");
  }
}
