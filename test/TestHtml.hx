import utest.UTest;

import utest.Assert;
using doom.HtmlNode;
import doom.Node;
import doom.Patch;

class TestHtml {
  var ref = js.Browser.document.getElementById("ref");
  public function new() {}

  public function testHtml() {
    var dom : js.html.Element = cast TestAll.el4.toHtml();
    Assert.equals("DIV", dom.nodeName);
    Assert.equals("value", dom.getAttribute("name"));
  }
}
