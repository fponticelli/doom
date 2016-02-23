import utest.UTest;

class TestAll {
  static function main() {
    UTest.run([
      new doom.core.TestInference(),
      new doom.core.TestSelectorParser(),
      new doom.core.TestVChildren(),
      new doom.html.TestAttributes(),
      new doom.html.TestRender(),
      new doom.html.TestComponent(),
    ]);
  }
}
