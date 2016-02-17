import utest.UTest;

class TestAll {
  static function main() {
    UTest.run([
      new doom.core.TestSelectorParser(),
      new doom.html.TestRender(),
      new doom.html.TestComponent()
    ]);
  }
}
