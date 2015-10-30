import utest.UTest;

import utest.Assert;
import doom.Doom;
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
    var empty = new Map();
    Assert.same([], Node.diffAttributes(empty, empty));
    Assert.same([RemoveAttribute("a")], Node.diffAttributes(["a" => "b"], empty));
    Assert.same([SetAttribute("a", "b")], Node.diffAttributes(empty, ["a" => "b"]));
    Assert.same([], Node.diffAttributes(["a" => "b"], ["a" => "b"]));
    Assert.same([SetAttribute("a", "c")], Node.diffAttributes(["a" => "b"], ["a" => "c"]));
  }

  public function testEventDiff() {
    var empty = new Map(),
        hb = function(_) {},
        hc = function(_) {};
    Assert.same([], Node.diffEvents(empty, empty));
    Assert.same([RemoveEvent("a")], Node.diffEvents(["a" => hb], empty));
    Assert.same([SetEvent("a", hb)], Node.diffEvents(empty, ["a" => hb]));
    Assert.same([], Node.diffEvents(["a" => hb], ["a" => hb]));
    Assert.same([SetEvent("a", hc)], Node.diffEvents(["a" => hb], ["a" => hc]));
  }

  static var emptys = new Map();
  static var emptye = new Map();
  static var el1 : Node = Element("a", emptys, emptye, []);
  static var el2 : Node = Element("div", emptys, emptye, [el1]);
  static var el3 : Node = Element("div", emptys, emptye, [el1, el1]);
  static var el4 : Node = Element("div", ["name" => "value"], emptye, [el1]);
  public function testChildrenDiff() {
    Assert.same([], el2.diff(el2));
    Assert.same([ReplaceWithElement("div", emptys, emptye, [el1])], el1.diff(el2));
    Assert.same([PatchChild(1, AddElement("a", emptys, emptye, []))], el2.diff(el3));
    Assert.same([PatchChild(1, Remove)], el3.diff(el2));
  }

  public function testToString() {
    Assert.equals('<div name="value"><a/></div>', Doom.nodeToString(el4));
  }

  public function testToXml() {
    Assert.equals('<div name="value"><a/></div>', Doom.nodeToXml(el4).toString());
  }
}
