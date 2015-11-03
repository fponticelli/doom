import utest.Assert;
using doom.HtmlNode;
using doom.Component;

class TestComponent {
  var dom : js.html.Element;
  public function new() {
    dom = js.Browser.document.getElementById("ref");
  }

  public function setup()
    dom.innerHTML = "";

  public function teardown()
    dom.innerHTML = "";

  public function testSome() {

  }
}
