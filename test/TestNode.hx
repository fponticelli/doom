import utest.Assert;
import doom.Node;
import doom.Node.*;
using doom.Patch;

class TestNode extends TestBase {
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

  public function testChildrenDiff() {
    Assert.same([], el2.diff(el2));
    Assert.same([ReplaceWithElement("div", emptys, emptye, [el1])], el1.diff(el2));
    Assert.same([AddElement("a", emptys, emptye, [])], el2.diff(el3));
    Assert.same([PatchChild(1, [Remove])], el3.diff(el2));
  }

  public function testIssue20151105() {
    var comments = [
            { author : "An Author", text : "This is one comment" },
            { author : "Some Guy", text : "This is *another* comment" }
          ],
        o = el("div", ["class" => "loading"], "Loading ..."),
        n = el("div",
              ["class" => "commentList"],
              comments.map(function(comment) return el("div",
                ["class" => "comment"],
                [el("h2",
                  ["class" => "comment"],
                  comment.author
                )],
                comment.text
              ))
            );
    var patches = o.diff(n);
    Assert.same(
      [
        SetAttribute("class", "commentList"),
        AddElement("div", ["class" => "comment"], new Map(), [
          el("h2",
            ["class" => "comment"],
            "Some Guy"
          ),
          text("This is *another* comment")
        ]),
        PatchChild(0, [ReplaceWithElement("div", ["class" => "comment"], new Map(),
          [
            el("h2",
              ["class" => "comment"],
              "An Author"
            ),
            text("This is one comment")
          ]
        )])
      ],
      patches
    );
  }

  public function testIssue20151107a() {
    var comments = [
            { author : "An Author", text : "This is one comment" },
            { author : "Some Guy", text : "This is *another* comment" }
          ],
        comments2 = [
            { author : "An Author", text : "This is one comment" },
            { author : "Some Guy", text : "This is *another* comment" },
            { author : "Someone Else", text : "With another comment" }
          ],
        o = el("div",
              ["class" => "commentList"],
              comments.map(function(comment) return el("div",
                ["class" => "comment"],
                [el("h2", comment.author)],
                comment.text
              ))
            ),
        n = el("div",
              ["class" => "commentList"],
              comments2.map(function(comment) return el("div",
                ["class" => "comment"],
                [el("h2", comment.author)],
                comment.text
              ))
            );
    var patches = o.diff(n);
    Assert.same(
      [
        AddElement("div", ["class" => "comment"], new Map(), [
          el("h2", "Someone Else"),
          text("With another comment")
        ])
      ],
      patches
    );
  }

  public function testIssue20151107b() {
    var comments = [
            { author : "An Author", text : "This is one comment" },
            { author : "Some Guy", text : "This is *another* comment" }
          ],
        o = el("div",
              ["class" => "commentList"],
              comments.map(function(comment) return el("div",
                ["class" => "comment"],
                [el("h2", comment.author)],
                comment.text
              ))
            ),
        n = el("div", ["class" => "loading"], "Loading ...");
    var patches = o.diff(n);
    Assert.same(
      [
        SetAttribute("class", "loading"),
        PatchChild(1, [Remove]),
        PatchChild(0, [ReplaceWithText("Loading ...")])
      ],
      patches
    );
  }

  public function testToString() {
    Assert.equals('<div name="value"><a/></div>', el4.toString());
  }

  public function testQuickBuilding() {
    var dom = el("div",
          ["class" => "some"],
          ["onclick" => function(_) trace("click")],
          [el("a",
            ["href" => "#"],
            [text("hello")]
          )]
        );
    Assert.equals('<div class="some"><a href="#">hello</a></div>', dom.toString());
  }
}
