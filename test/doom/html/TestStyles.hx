package doom.html;

import utest.Assert;

class TestStyles extends Base {
  public function testHasClasses() {
    var a = new A({});
    Assert.equals("doom_html__test-styles_a", a.classes());
    var b = new B({});
    Assert.equals("doom_html__test-styles_b doom_html__test-styles_a", b.classes());
  }
}

private class A extends doom.html.Component<{}> {

}

private class B extends A {

}
