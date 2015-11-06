import utest.Assert;
import doom.Node.*;
using doom.Component;

class TestComponent extends TestBaseHtml {
  public function testBasic() {
    var component = new SimpleComponent();
    component.mount(dom);
    Assert.equals("", dom.innerHTML);
    component.update(5);
    Assert.equals("<span>5</span>", dom.innerHTML);
  }

  public function testUpdate() {
    var component = new SimpleComponent();
    component.mount(dom);
    component.update(1);
    Assert.equals("<span>1</span>", dom.innerHTML);
    component.update(2);
    Assert.equals("<span>2</span>", dom.innerHTML);
    component.update(3);
    Assert.equals("<span>3</span>", dom.innerHTML);
  }

  public function testNested() {
    var component = new ContainerComponent();
    component.mount(dom);
    component.update({ name : "doom", value : 1 });
    Assert.equals('<div class="doom"><span>1</span></div>', dom.innerHTML);
    component.update({ name : "thx", value : 1 });
    Assert.equals('<div class="thx"><span>1</span></div>', dom.innerHTML);
    component.update({ name : "thx", value : 2 });
    Assert.equals('<div class="thx"><span>2</span></div>', dom.innerHTML);
  }

  public function testUpdateNested() {
    var done = Assert.createAsync(),
        component = new ContainerUpdatingComponent();
    component.mount(dom);
    component.update({ name : "doom", value : 1 });
    Assert.equals('<div class="doom"><span>1</span></div>', dom.innerHTML);
    thx.Timer.delay(function() {
      Assert.equals('<div class="doom"><span>2</span></div>', dom.innerHTML);
      done();
    }, 20);
  }
}

class SimpleComponent extends Component<Int> {
  var selfUpdating : Bool;
  public function new(selfUpdating = false) {
    super();
    this.selfUpdating = selfUpdating;
  }
  override function render(value : Int) {
    if(selfUpdating) {
      selfUpdating = false;
      thx.Timer.delay(function() update(value+1), 10);
    }
    return el("span", '$value');
  }
}

class ContainerComponent extends Component<{ name : String, value : Int }> {
  override function render(t : { name : String, value : Int })
    return el('div', ["class" => t.name], new SimpleComponent().view(t.value));
}

class ContainerUpdatingComponent extends Component<{ name : String, value : Int }> {
  override function render(t : { name : String, value : Int })
    return el('div', ["class" => t.name], new SimpleComponent(true).view(t.value));
}
