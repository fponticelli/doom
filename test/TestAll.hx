import utest.UTest;

class TestAll {
  static function main() {
    UTest.run([
      new doom.core.TestSelectorParser(),
      new doom.html.TestAttributes(),
      new doom.html.TestRender(),
      new doom.html.TestComponent()
    ]);
  }
}

/*
TODO
  events
    add
    replace
    remove
  renderers
    subnodes ?
  components that alterate the dom
  async components that alterate the dom
*/
