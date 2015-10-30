import utest.UTest;

import utest.Assert;
import doom.*;
import doom.Node;

class TestAll {
  static function main() {
    UTest.run([
      new TestAll()
    ]);
  }

  public function new() {}

  public function testDiffEmpty() {
    var node : Node = Empty;
    Assert.same([], node.diff(Empty));
  }
}
