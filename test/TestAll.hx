import utest.UTest;

class TestAll {
  static function main() {
    UTest.run([
      new TestDoom(),
      new TestNode(),
      new TestXml(),
      new TestSelectorParser(),
      new TestHtml(),
      new TestComponent()
    ]);
  }
}
