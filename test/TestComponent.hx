import utest.Assert;
import doom.Node.*;
using doom.Component;

class TestComponent extends TestBaseHtml {
  public function testBasic() {
    var component = new SimpleComponent({}, 0, null, false);
    Doom.mount(component, dom);
    Assert.equals("", dom.innerHTML);
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
}

class SimpleComponent extends Component<{}, Int> {
  var selfUpdating : Bool;
  public function new(api, state, children, selfUpdating = false) {
    super(api, state, children);
    this.selfUpdating = selfUpdating;
  }
  override function render() {
    if(selfUpdating) {
      selfUpdating = false;
      thx.Timer.delay(function() update(state+1), 10);
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
