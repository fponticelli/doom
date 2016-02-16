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

    trace(comp.phases);
    Assert.same([
      { phase : WillMount, hasElement : false, isUnmounted : false },
      { phase : Render,    hasElement : false, isUnmounted : false },
      { phase : DidMount,  hasElement : true,  isUnmounted : false },
      { phase : Render,    hasElement : true, isUnmounted : false },
    ], comp.phases);
  }

  public function testComponentReplacedBySame() {
    // A -> A
  }

  public function testComponentReplacedByDifferent() {
    // A -> B
    // B -> A
  }

  public function testComponentReplacedByElement() {
    // A -> Element
  }

  public function testElementReplacedByComponent() {
    // Element -> A
  }
}

private class SampleComponent extends doom.html.Component<{}> {
  public var phases : Array<PhaseInfo> = [];

  override function willMount() {
    addPhase(WillMount);
  }
  override function render() {
    addPhase(Render);
    return Element("div", new Map(), children);
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
