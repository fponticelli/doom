import utest.UTest;

import utest.Assert;
import doom.Node;
import doom.Patch;

class TestAll {
  static function main() {
    UTest.run([
      new TestAll()
    ]);
  }

  public function new() {}

  public function testDiff() {
    Assert.same([], (Empty : Node).diff(Empty));
    Assert.same([], (Text("a") : Node).diff(Text("a")));
    Assert.same([ContentChanged("b")], (Text("a") : Node).diff(Text("b")));
    Assert.same([ReplaceWithText("b")], (Empty : Node).diff(Text("b")));
    Assert.same([ReplaceWithComment("b")], (Empty : Node).diff(Comment("b")));
    Assert.same([Remove], (Text("a") : Node).diff(Empty));
  }

  public function testAttributeDiff() {

  }

  public function testEventDiff() {

  }

  public function testChildrenDiff() {

  }
}
