import utest.UTest;

class TestAll {
  static function main() {
    UTest.run([
      new doom.core.TestInference(),
      new doom.html.TestAttributes(),
      new doom.html.TestRender(),
      new doom.html.TestComponent(),
      new doom.html.TestStream(),
      new doom.html.TestStyles(),
    ]);
    doom.html.Css.save("bin/styles.css");
  }
}
