import utest.UTest;

class TestAll {
  static function main() {
    UTest.run([
      new TestNode(),
      new TestXml(),
      #if (js && html)
      new TestHtml(),
      new TestComponent()
      #end
    ]);
  }
}
