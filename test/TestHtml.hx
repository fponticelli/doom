import utest.Assert;
using doom.HtmlNode;
import doom.Patch;

class TestHtml extends TestBaseHtml {
  public function testHtml() {
    var dom : js.html.Element = cast el4.toHtml();
    Assert.equals("DIV", dom.nodeName);
    Assert.equals("value", dom.getAttribute("name"));
  }

  public function testHtmlPatch() {
    var patches = [
          SetAttribute("name", "value"),
          AddElement("a", ["href" => "#"], null, []),
          PatchChild(0, [AddText("hello")])
        ];
    HtmlNode.applyPatches(patches, dom);
    Assert.equals("DIV", dom.nodeName);
    Assert.equals("value", dom.getAttribute("name"));
    Assert.equals("A", dom.firstElementChild.nodeName);
    Assert.equals("#", dom.firstElementChild.getAttribute("href"));
    Assert.equals("hello", dom.firstElementChild.textContent);
  }
}
