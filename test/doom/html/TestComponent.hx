package doom.html;

import utest.Assert;
import doom.core.VNode;
import js.html.Node;

class TestComponent {
  public function new() {}

  var render : Render;
  public function setup() {
    render = new Render();
  }
  public function teardown() {
    js.Browser.document.body.innerHTML = "";
  }

  public function testSimpleLifecycle() {
    var comp = new SampleComponent({}, []);
    Assert.same([], comp.phases);
    render.mount(comp, js.Browser.document.body);
    Assert.same([
      { phase : WillMount, hasElement : false, isUnmounted : false },
      { phase : Render,    hasElement : false, isUnmounted : false },
      { phase : DidMount,  hasElement : true,  isUnmounted : false },
    ], comp.phases);
  }

  public function testUpdate() {
    var comp = new SampleComponent({}, []);
    render.mount(comp, js.Browser.document.body);
    comp.update({});

    Assert.same([
      { phase : WillMount, hasElement : false, isUnmounted : false },
      { phase : Render,    hasElement : false, isUnmounted : false },
      { phase : DidMount,  hasElement : true,  isUnmounted : false },
      { phase : Render,    hasElement : true,  isUnmounted : false },
    ], comp.phases);
  }

  public function testComponentInsideElement() {
    var comp = new SampleComponent({}, []),
        div   = doom.html.Html.div(["class" => "container"], comp);
    render.mount(div, js.Browser.document.body);
    var dom = js.Browser.document.body.querySelector(".container");
    Assert.same([
      { phase : WillMount, hasElement : false, isUnmounted : false },
      { phase : Render,    hasElement : false, isUnmounted : false },
      { phase : DidMount,  hasElement : true,  isUnmounted : false }
    ], comp.phases);
    comp.phases = [];
    render.apply(div, dom);
    Assert.same([
      { phase : Render,    hasElement : true,  isUnmounted : false }
    ], comp.phases);
  }

  public function testComponentReplacedBySame() {
    var comp1 = new SampleComponent({}, []),
        comp2 = new SampleComponent({}, []),
        div   = doom.html.Html.div(["class" => "container"], comp1);
    render.mount(div, js.Browser.document.body);
    var dom = js.Browser.document.body.querySelector(".container");
    comp1.phases = [];
    div = doom.html.Html.div(["class" => "container"], comp2);
    render.apply(div, dom);
    Assert.same([
      { phase : Render,    hasElement : true, isUnmounted : false }
    ], comp1.phases);
    Assert.same([], comp2.phases);
  }

  public function testComponentReplacedBySameUpdateComp1() {
    var comp1 = new SampleComponent({}, []),
        comp2 = new SampleComponent({}, []),
        div   = doom.html.Html.div(["class" => "container"], comp1);
    render.mount(div, js.Browser.document.body);
    var dom = js.Browser.document.body.querySelector(".container");
    div = doom.html.Html.div(["class" => "container"], comp2);
    render.apply(div, dom);
    comp1.phases = [];
    comp1.update({});
    Assert.same([
      { phase : Render,    hasElement : true, isUnmounted : false }
    ], comp1.phases);
    Assert.same([], comp2.phases);
  }

  public function testComponentReplacedBySameUpdateComp2() {
    var comp1 = new SampleComponent({}, []),
        comp2 = new SampleComponent({}, []),
        div   = doom.html.Html.div(["class" => "container"], comp1);
    render.mount(div, js.Browser.document.body);
    var dom = js.Browser.document.body.querySelector(".container");
    div = doom.html.Html.div(["class" => "container"], comp2);
    render.apply(div, dom);
    comp1.phases = [];
    comp2.update({});
    Assert.same([
      { phase : Render,    hasElement : true, isUnmounted : false }
    ], comp1.phases);
    Assert.same([], comp2.phases);
  }

  public function testComponentReplacedByDifferent() {
    var comp1 = new SampleComponent({}, []),
        comp2 = new SampleComponent2({}, []),
        div   = doom.html.Html.div(["class" => "container"], comp1);
    render.mount(div, js.Browser.document.body);
    var dom = js.Browser.document.body.querySelector(".container");
    div = doom.html.Html.div(["class" => "container"], comp2);
    render.apply(div, dom);
    Assert.same([
      { phase : WillMount,   hasElement : false, isUnmounted : false },
      { phase : Render,      hasElement : false, isUnmounted : false },
      { phase : DidMount,    hasElement : true,  isUnmounted : false },
      { phase : WillUnmount, hasElement : true,  isUnmounted : false },
      { phase : DidUnmount,  hasElement : false,  isUnmounted : true },
    ], comp1.phases);
    Assert.same([
      { phase : WillMount, hasElement : false, isUnmounted : false },
      { phase : Render,    hasElement : false, isUnmounted : false },
      { phase : DidMount,  hasElement : true,  isUnmounted : false }
    ], comp2.phases);
    comp1.phases = [];
    comp1.update({}); // should do nothing
    Assert.same([], comp1.phases);
    comp2.phases = [];
    comp2.update({}); // should do nothing
    Assert.same([{ phase : Render, hasElement : true, isUnmounted : false }], comp2.phases);
  }

  public function testComponentReplacedByElement() {
    var comp = new SampleComponent({}, []),
        el   = doom.html.Html.div(["class" => "some"], []),
        div  = doom.html.Html.div(["class" => "container"], comp);
    render.mount(div, js.Browser.document.body);
    var dom = js.Browser.document.body.querySelector(".container");
    Assert.same([
      { phase : WillMount,   hasElement : false, isUnmounted : false },
      { phase : Render,      hasElement : false, isUnmounted : false },
      { phase : DidMount,    hasElement : true,  isUnmounted : false },
    ], comp.phases);

    comp.phases = [];
    div = doom.html.Html.div(["class" => "container"], el);
    render.apply(div, dom);
    Assert.same([
      { phase : WillUnmount, hasElement : true,  isUnmounted : false },
      { phase : DidUnmount,  hasElement : false, isUnmounted : true },
    ], comp.phases);
    comp.phases = [];
    comp.update({}); // should do nothing
    Assert.same([], comp.phases);
  }

  public function testElementReplacedByComponent() {
    var comp = new SampleComponent({}, []),
        el   = doom.html.Html.div(["class" => "some"], []),
        div  = doom.html.Html.div(["class" => "container"], el);
    render.mount(div, js.Browser.document.body);
    var dom = js.Browser.document.body.querySelector(".container");
    div = doom.html.Html.div(["class" => "container"], comp);
    render.apply(div, dom);
    Assert.same([
      { phase : WillMount,   hasElement : false, isUnmounted : false },
      { phase : Render,      hasElement : false, isUnmounted : false },
      { phase : DidMount,    hasElement : true,  isUnmounted : false }
    ], comp.phases);
    comp.phases = [];
    comp.update({}); // should do nothing
    Assert.same([{ phase : Render, hasElement : true, isUnmounted : false }], comp.phases);
  }

  public function testComponentIsRemovedFromDom() {
    var comp = new SampleComponent({}, []),
        div  = doom.html.Html.div(["class" => "container"], comp);
    render.mount(div, js.Browser.document.body);
    var dom = js.Browser.document.body.querySelector(".container");
    div = doom.html.Html.div(["class" => "container"]);
    comp.phases = [];
    render.apply(div, dom);
    Assert.same([
      { phase : WillUnmount, hasElement : true, isUnmounted : false },
      { phase : DidUnmount,  hasElement : false,  isUnmounted : true }
    ], comp.phases);
    comp.phases = [];
    comp.update({}); // should do nothing
    Assert.same([], comp.phases);
  }
}

private class SampleComponent2 extends SampleComponent {}

private class SampleComponent extends doom.html.Component<{}> {
  public var phases : Array<PhaseInfo> = [];

  override function willMount() {
    addPhase(WillMount);
  }
  override function render() {
    addPhase(Render);
    return Element("span", ["class" => "sample"], children);
  }
  override function didMount() {
    addPhase(DidMount);
  }
  override function willUnmount() {
    addPhase(WillUnmount);
  }
  override function didUnmount() {
    addPhase(DidUnmount);
  }

  function addPhase(phase : Phase) {
    phases.push({
      phase : phase,
      hasElement : element != null,
      isUnmounted : isUnmounted
    });
  }
}

private typedef PhaseInfo = {
  phase : Phase,
  hasElement : Bool,
  isUnmounted : Bool
}

private enum Phase {
  WillMount;
  Render;
  DidMount;
  WillUnmount;
  DidUnmount;
}
