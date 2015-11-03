import doom.Node;

class TestBase {
  var emptys : Map<String, String> = new Map();
  var emptye : Map<String, doom.EventHandler> = new Map();
  var el1 : Node;
  var el2 : Node;
  var el3 : Node;
  var el4 : Node;

  public function new() {}

  public function setup() {
    emptys = new Map();
    emptye = new Map();
    el1 = Element("a", emptys, emptye, []);
    el2 = Element("div", emptys, emptye, [el1]);
    el3 = Element("div", emptys, emptye, [el1, el1]);
    el4 = Element("div", ["name" => "value"], emptye, [el1]);
  }
}
