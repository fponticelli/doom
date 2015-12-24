import utest.Assert;
import doom.Node.*;
using doom.Component;
import Doom.*;

class TestComponent extends TestBaseHtml {
  public function testBasic() {
    var component = new SimpleComponent({}, 0, null, false);
    Doom.mount(component, dom);
    Assert.equals("<span>0</span>", dom.innerHTML);
    component.update(5);
    Assert.equals("<span>5</span>", dom.innerHTML);
  }

  public function testUpdate() {
    var component = new SimpleComponent({}, 0, null, false);
    Doom.mount(component, dom);
    component.update(1);
    Assert.equals("<span>1</span>", dom.innerHTML);
    component.update(2);
    Assert.equals("<span>2</span>", dom.innerHTML);
    component.update(3);
    Assert.equals("<span>3</span>", dom.innerHTML);
  }

  public function testNested() {
    var component = new ContainerComponent({}, {name : "some", value : 1});
    Doom.mount(component, dom);
    component.update({ name : "doom", value : 1 });
    Assert.equals('<div class="doom"><span>1</span></div>', dom.innerHTML);
    component.update({ name : "thx", value : 1 });
    Assert.equals('<div class="thx"><span>1</span></div>', dom.innerHTML);
    component.update({ name : "thx", value : 2 });
    Assert.equals('<div class="thx"><span>2</span></div>', dom.innerHTML);
  }

  public function testUpdateNested() {
    var done = Assert.createAsync(),
        component = new ContainerUpdatingComponent({}, {name : "some", value : 1});
    Doom.mount(component, dom);
    component.update({ name : "doom", value : 1 });
    Assert.equals('<div class="doom"><span>1</span></div>', dom.innerHTML);
    thx.Timer.delay(function() {
      Assert.equals('<div class="doom"><span>2</span></div>', dom.innerHTML);
      done();
    }, 20);
  }

  public function testDomMount() {
    var counter = 0;
    var comp = new ComponentPhases(function() ++counter);
    var done = Assert.createAsync();
    Assert.equals(0, counter);
    Doom.mount(comp, dom);
    thx.Timer.delay(function() {
      Assert.equals(1, counter);
      comp.update({});
      Assert.equals(1, counter);
      done();
    }, 10);
  }

  public function testMountUpdate() {
    var counter = 0;
    var comp = new ParentComponent({}, {}, [
        comp(new ComponentPhases(function() ++counter)),
        comp(new ComponentPhases(function() ++counter))
      ]);
    var done = Assert.createAsync();
    Assert.equals(0, counter);
    Doom.mount(comp, dom);
    thx.Timer.delay(function() {
      Assert.equals(2, counter);
      comp.update({});
      Assert.equals(2, counter);
      done();
    }, 10);
  }
}

class SimpleComponent extends Component<{}, Int> {
  var selfUpdating : Bool;
  public function new(api, state, children, selfUpdating = false) {
    this.selfUpdating = selfUpdating;
    super(api, state, children);
  }
  override function render() {
    if(selfUpdating) {
      selfUpdating = false;
      thx.Timer.delay(function() {
        update(state+1);
      }, 2);
    }
    return el("span", '$state');
  }
}

class ContainerComponent extends Component<{}, { name : String, value : Int }> {
  override function render()
    return el('div', ["class" => state.name], new SimpleComponent({}, state.value, null, false));
}

class ContainerUpdatingComponent extends Component<{}, { name : String, value : Int }> {
  override function render()
    return el('div', ["class" => state.name], new SimpleComponent({}, state.value, null, true));
}

class ParentComponent extends doom.Component<{}, {}> {
  override function render()
    return div(children);
}

class ComponentPhases extends doom.Component<{}, {}> {
  var mountHandle : Void -> Void;
  public function new(mountHandle : Void -> Void) {
    this.mountHandle = mountHandle;
    super({}, {});
  }

  override function render()
    return div("first render");

  override function mount() {
    mountHandle();
  }
}
