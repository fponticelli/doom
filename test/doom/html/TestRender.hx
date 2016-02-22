package doom.html;

import js.Browser.*;
import utest.Assert;
import doom.core.VNode;
import dots.Html;
import doom.html.Html.*;

class TestRender extends Base {
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

  public function testMountElement() {
    mount(div(["class" => "some"]));
    assertHtml('<div class="some"></div>');
  }

  public function testApplyText2Text() {
    mount(text("hello"));
    assertHtml('hello');
    apply(text("ciao"));
    assertHtml('ciao');
  }

  public function testApplyText2Comment() {
    mount(comment("hello"));
    assertHtml('<!--hello-->');
    apply(text("ciao"));
    assertHtml('ciao');
  }

  public function testApplyText2Element() {
    mount(div());
    assertHtml('<div></div>');
    apply(text("ciao"));
    assertHtml('ciao');
  }

  public function testApplyText2Raw() {
    mount(raw("<div>hello</div>"));
    assertHtml('<div>hello</div>');
    apply(text("ciao"));
    assertHtml('ciao');
  }

  public function testApplyText2Component() {
    mount(comp(new SampleComponent({}, [])));
    assertHtml('<span>component</span>');
    apply(text("ciao"));
    assertHtml('ciao');
  }

  public function testApplyComment2Comment() {
    mount(comment("hello"));
    assertHtml('<!--hello-->');
    apply(comment("ciao"));
    assertHtml('<!--ciao-->');
  }

  public function testApplyComment2Text() {
    mount(text("hello"));
    assertHtml('hello');
    apply(comment("ciao"));
    assertHtml('<!--ciao-->');
  }

  public function testApplyComment2Raw() {
    mount(raw("<div>hello</div>"));
    assertHtml('<div>hello</div>');
    apply(comment("ciao"));
    assertHtml('<!--ciao-->');
  }

  public function testApplyComment2Element() {
    mount(div("hello"));
    assertHtml('<div>hello</div>');
    apply(comment("ciao"));
    assertHtml('<!--ciao-->');
  }

  public function testApplyComment2Component() {
    mount(comp(new SampleComponent({}, [])));
    assertHtml('<span>component</span>');
    apply(comment("ciao"));
    assertHtml('<!--ciao-->');
  }

  public function testApplyElement2ElementSameTag() {
    mount(div("ciao"));
    assertHtml('<div>ciao</div>');
    apply(div("hello"));
    assertHtml('<div>hello</div>');
  }

  public function testApplyElement2ElementSameTagDifferentAttributes() {
    mount(div(["class" => "some"], "ciao"));
    assertHtml('<div class="some">ciao</div>');
    apply(div(["id" => "main"], "hello"));
    assertHtml('<div id="main">hello</div>');
  }

  public function testApplyElement2ElementDifferentTag() {
    mount(div("ciao"));
    assertHtml('<div>ciao</div>');
    apply(span("hello"));
    assertHtml('<span>hello</span>');
  }

  public function testApplyElement2Text() {
    mount(text("ciao"));
    assertHtml('ciao');
    apply(div("hello"));
    assertHtml('<div>hello</div>');
  }

  public function testApplyElement2Comment() {
    mount(comment("ciao"));
    assertHtml('<!--ciao-->');
    apply(div("hello"));
    assertHtml('<div>hello</div>');
  }

  public function testApplyElement2Raw() {
    mount(raw("<div>hello</div>"));
    assertHtml('<div>hello</div>');
    apply(div("ciao"));
    assertHtml('<div>ciao</div>');
  }

  public function testApplyElement2RawDifferentElement() {
    mount(raw("<div>hello</div>"));
    assertHtml('<div>hello</div>');
    apply(span("ciao"));
    assertHtml('<span>ciao</span>');
  }

  public function testApplyElement2Component() {
    mount(comp(new SampleComponent({}, [])));
    assertHtml('<span>component</span>');
    apply(div("ciao"));
    assertHtml('<div>ciao</div>');
  }

  public function testApplyRaw2Component() {
    mount(comp(new SampleComponent({}, [])));
    assertHtml('<span>component</span>');
    apply(raw("<div>hello</div>"));
    assertHtml('<div>hello</div>');
  }

  public function testApplyRaw2ElementSameTag() {
    mount(div("hello"));
    assertHtml('<div>hello</div>');
    apply(raw("<div>ciao</div>"));
    assertHtml('<div>ciao</div>');
  }

  public function testApplyRaw2ElementDifferentTag() {
    mount(div("hello"));
    assertHtml('<div>hello</div>');
    apply(raw("<span>ciao</span>"));
    assertHtml('<span>ciao</span>');
  }

  public function testApplyRaw2Comment() {
    mount(comment("ciao"));
    assertHtml('<!--ciao-->');
    apply(raw("<span>hello</span>"));
    assertHtml('<span>hello</span>');
  }

  public function testApplyRaw2Text() {
    mount(text("ciao"));
    assertHtml('ciao');
    apply(raw("<span>hello</span>"));
    assertHtml('<span>hello</span>');
  }

  public function testApplyMultiRaw2Element() {
    mount(div("ciao"));
    apply(raw("<script>olà</script><span>hello</span>"));
    assertHtml('<script>olà</script><span>hello</span>');
  }

  public function testApplyTextarea2Textarea() {
    mount(textarea("ciao"));
    assertHtml('<textarea>ciao</textarea>');
    apply(textarea("hello"));
    assertHtml('<textarea>hello</textarea>');
  }
}

private class SampleComponent extends doom.html.Component<{}> {
  override function render() {
    return span("component");
  }
}
