package doom.html;

import utest.Assert;
import doom.core.VNode;
import js.html.Node;
import doom.html.Phase;
import doom.html.Html.*;

class TestComponent extends Base {
  public function testSimpleLifecycle() {
    var comp = new SampleComponent({}, []);
    Assert.same([], comp.phases);
    mount(comp);
    Assert.same([
      { phase : WillMount, hasElement : false, isUnmounted : false },
      { phase : Render,    hasElement : false, isUnmounted : false },
      { phase : DidMount,  hasElement : true,  isUnmounted : false },
    ], comp.phases);
  }

  public function testUpdate() {
    var comp = new SampleComponent({}, []);
    mount(comp);
    comp.update({});

    Assert.same([
      { phase : WillMount,  hasElement : false, isUnmounted : false },
      { phase : Render,     hasElement : false, isUnmounted : false },
      { phase : DidMount,   hasElement : true,  isUnmounted : false },
      { phase : WillUpdate, hasElement : true,  isUnmounted : false },
      { phase : Render,     hasElement : true,  isUnmounted : false },
      { phase : DidUpdate,  hasElement : true,  isUnmounted : false }
    ], comp.phases);
  }

  public function testComponentInsideElement() {
    var comp = new SampleComponent({}, []),
        div   = doom.html.Html.div(["class" => "container"], comp);
    mount(div);
    var dom = select(".container");
    Assert.same([
      { phase : WillMount, hasElement : false, isUnmounted : false },
      { phase : Render,    hasElement : false, isUnmounted : false },
      { phase : DidMount,  hasElement : true,  isUnmounted : false }
    ], comp.phases);
    comp.phases = [];
    render.apply(div, dom);
    Assert.same([
      { phase : WillUpdate, hasElement : true, isUnmounted : false },
      { phase : Render,     hasElement : true, isUnmounted : false },
      { phase : DidUpdate,  hasElement : true, isUnmounted : false }
    ], comp.phases);
  }

  public function testComponentReplacedBySame() {
    var comp1 = new SampleComponent({}, []),
        comp2 = new SampleComponent({}, []),
        div   = doom.html.Html.div(["class" => "container"], comp1);
    mount(div);
    var dom = select(".container");
    comp1.phases = [];
    div = doom.html.Html.div(["class" => "container"], comp2);
    render.apply(div, dom);
    Assert.same([
      { phase : WillUpdate, hasElement : true, isUnmounted : false },
      { phase : Render,     hasElement : true, isUnmounted : false },
      { phase : DidUpdate,  hasElement : true, isUnmounted : false }
    ], comp1.phases);
    Assert.same([], comp2.phases);
  }

  public function testComponentReplacedBySameUpdateComp1() {
    var comp1 = new SampleComponent({}, []),
        comp2 = new SampleComponent({}, []),
        div   = doom.html.Html.div(["class" => "container"], comp1);
    mount(div);
    var dom = select(".container");
    div = doom.html.Html.div(["class" => "container"], comp2);
    render.apply(div, dom);
    comp1.phases = [];
    comp1.update({});
    Assert.same([
      { phase : WillUpdate, hasElement : true, isUnmounted : false },
      { phase : Render,     hasElement : true, isUnmounted : false },
      { phase : DidUpdate,  hasElement : true, isUnmounted : false }
    ], comp1.phases);
    Assert.same([], comp2.phases);
  }

  public function testComponentReplacedBySameUpdateComp2() {
    var comp1 = new SampleComponent({}, []),
        comp2 = new SampleComponent({}, []),
        div   = doom.html.Html.div(["class" => "container"], comp1);
    mount(div);
    var dom = select(".container");
    div = doom.html.Html.div(["class" => "container"], comp2);
    render.apply(div, dom);
    comp1.phases = [];
    comp2.update({});
    Assert.same([
      { phase : WillUpdate, hasElement : true, isUnmounted : false },
      { phase : Render,     hasElement : true, isUnmounted : false },
      { phase : DidUpdate,  hasElement : true, isUnmounted : false }
    ], comp1.phases);
    Assert.same([], comp2.phases);
  }

  public function testComponentReplacedByDifferent() {
    var comp1 = new SampleComponent({}, []),
        comp2 = new SampleComponent2({}, []),
        div   = doom.html.Html.div(["class" => "container"], comp1);
    mount(div);
    var dom = select(".container");
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
    Assert.same([
      { phase : WillUpdate, hasElement : true,  isUnmounted : false },
      { phase : Render, hasElement : true, isUnmounted : false },
      { phase : DidUpdate,  hasElement : true, isUnmounted : false }
    ], comp2.phases);
  }

  public function testComponentReplacedByElement() {
    var comp = new SampleComponent({}, []),
        el   = doom.html.Html.div(["class" => "some"], []),
        div  = doom.html.Html.div(["class" => "container"], comp);
    mount(div);
    var dom = select(".container");
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
    mount(div);
    var dom = select(".container");
    div = doom.html.Html.div(["class" => "container"], comp);
    render.apply(div, dom);
    Assert.same([
      { phase : WillMount,   hasElement : false, isUnmounted : false },
      { phase : Render,      hasElement : false, isUnmounted : false },
      { phase : DidMount,    hasElement : true,  isUnmounted : false }
    ], comp.phases);
    comp.phases = [];
    comp.update({}); // should do nothing
    Assert.same([
      { phase : WillUpdate, hasElement : true, isUnmounted : false },
      { phase : Render, hasElement : true, isUnmounted : false },
      { phase : DidUpdate,  hasElement : true, isUnmounted : false }
    ], comp.phases);
  }

  public function testComponentIsRemovedFromDom() {
    var comp = new SampleComponent({}, []),
        div  = doom.html.Html.div(["class" => "container"], comp);
    mount(div);
    var dom = select(".container");
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

  public function testNestedComponentUpdate() {
    var comp = new NestedComponent({ counter : 1 });
    mount(comp);
    assertHtml('<div><div><div>counter: 1</div></div></div>');
    comp.update({ counter : 2 });
    assertHtml('<div><div><div>counter: 2</div></div></div>');
  }

  public function testSwitchNodeTypeBetweenTextAndElement() {
    var comp = new SwitchingComponent({ type : Div });
    mount(comp);
    assertHtml('<div class="container"></div>');
    comp.update({ type : Text });
    assertHtml('just text');
    comp.update({ type : Div });
    assertHtml('<div class="container"></div>');
    comp.update({ type : Text });
    assertHtml('just text');
  }

  public function testSwitchNodeTypeBetweenElementAndText() {
    var comp = new SwitchingComponent({ type : Text });
    mount(comp);
    assertHtml('just text');
    comp.update({ type : Div });
    assertHtml('<div class="container"></div>');
    comp.update({ type : Text });
    assertHtml('just text');
    comp.update({ type : Div });
    assertHtml('<div class="container"></div>');
  }

  public function testSwitchNodeTypeBetweenElements() {
    var comp = new SwitchingComponent({ type : Div });
    mount(comp);
    assertHtml('<div class="container"></div>');
    comp.update({ type : Span });
    assertHtml('<span class="inline"></span>');
    comp.update({ type : Div });
    assertHtml('<div class="container"></div>');
    comp.update({ type : Span });
    assertHtml('<span class="inline"></span>');
    Assert.same([
      { phase : WillMount,  hasElement : false, isUnmounted : false },
      { phase : Render,     hasElement : false, isUnmounted : false },
      { phase : DidMount,   hasElement : true,  isUnmounted : false },
      { phase : WillUpdate, hasElement : true,  isUnmounted : false },
      { phase : Render,     hasElement : true,  isUnmounted : false },
      { phase : DidUpdate,  hasElement : true,  isUnmounted : false },
      { phase : WillUpdate, hasElement : true,  isUnmounted : false },
      { phase : Render,     hasElement : true,  isUnmounted : false },
      { phase : DidUpdate,  hasElement : true,  isUnmounted : false },
      { phase : WillUpdate, hasElement : true,  isUnmounted : false },
      { phase : Render,     hasElement : true,  isUnmounted : false },
      { phase : DidUpdate,  hasElement : true,  isUnmounted : false },
    ], comp.phases);
  }

  public function testComponentReturnsComponent() {
    var comp = new ComponentA({});
    mount(comp);
    assertHtml('<div></div>');
  }
}

private class ComponentA extends doom.html.Component<{}> {
  override function render() : VNode return new ComponentB({});
}

private class ComponentB extends doom.html.Component<{}> {
  override function render() : VNode return div();
}

private class NestedComponent extends doom.html.Component<{ counter : Int }> {
  override function render()
    return div(div(new ChildComponent({ counter : props.counter })));
}

private class ChildComponent extends doom.html.Component<{ counter : Int }> {
  override function render()
    return div('counter: ${props.counter}');
}

private class SampleComponent2 extends SampleComponent<{}> {}

private class SampleComponent<T> extends doom.html.Component<T> {
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
  override function willUpdate() {
    addPhase(WillUpdate);
  }
  override function didUpdate() {
    addPhase(DidUpdate);
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
      hasElement : node != null,
      isUnmounted : isUnmounted
    });
  }
}

private class SwitchingComponent extends SampleComponent<{ type : NodeType }> {
  override function render() {
    addPhase(Render);
    return switch props.type {
      case Div: div(["class" => "container"]);
      case Span: span(["class" => "inline"]);
      case Text: text("just text");
    };
  }
}

private enum NodeType {
  Div;
  Span;
  Text;
}
