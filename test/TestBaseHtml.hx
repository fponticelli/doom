class TestBaseHtml extends TestBase {
  var dom : js.html.Element;
  public function new() {
    dom = js.Browser.document.getElementById("ref");
    super();
  }

  override public function setup() {
    dom.innerHTML = "";
    super.setup();
  }

  public function teardown()
    dom.innerHTML = "";
}
