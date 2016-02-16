package doom.html;

import utest.Assert;
import doom.core.VNode;

class TestComponent {
  public function new() {}

  public function testLifecycle() {
    var doom = new doom.html.Render(),
        comp = new SampleComponent({}, []);
    Assert.equals(0, comp.counter);
    doom.mount(comp, js.Browser.document.body);
    Assert.equals(3, comp.counter);
  }
}

private class SampleComponent extends doom.html.Component<{}> {
  public var counter = 0;

  override function willMount() {
    counter++;
    Assert.equals(1, counter);
    Assert.isNull(element);
  }
  override function render() {
    counter++;
    Assert.equals(2, counter);
    return Element("div", new Map(), children);
  }
  override function didMount() {
    counter++;
    Assert.equals(3, counter);
    Assert.notNull(element);
  }
  override function willUnmount() {
    counter++;
    Assert.equals(4, counter);
    Assert.notNull(element);
  }
  override function didUnmount() {
    counter++;
    Assert.equals(5, counter);
    Assert.isNull(element);
  }
}
