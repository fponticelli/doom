import doom.Node;
import doom.AttributeValue;

class TestBase {
  var emptys : Map<String, AttributeValue> = new Map();
  var el1 : Node;
  var el2 : Node;
  var el3 : Node;
  var el4 : Node;

  public function new() {}

  public function setup() {
    emptys = new Map();
    el1 = Element("a", emptys, []);
    el2 = Element("div", emptys, [el1]);
    el3 = Element("div", emptys, [el1, el1]);
    el4 = Element("div", ["name" => "value"], [el1]);
  }
}
