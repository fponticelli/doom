import utest.UTest;

class TestAll {
  static function main() {
    UTest.run([
      new doom.html.TestRender(),
      new doom.html.TestComponent()
      // new TestDoom(),
      // new TestNode(),
      // new TestXml(),
      // new TestSelectorParser(),
      // new TestHtml(),
      // new TestComponent(),
      // new TestAutoComponent(),
    ]);
  }
}
