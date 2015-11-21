import doom.PropertiesStatelessComponent;
import doom.HTML.*;
import dots.Keys;
import js.html.*;
using thx.Strings;

class ToDoHeader extends PropertiesStatelessComponent<AddToDoItem> {
  override function render() {
    return HEADER([
        "class" => "header"
      ], [
        H1("todos"),
        INPUT([
          "class"       => "new-todo",
          "placeholder" => "What needs to be done?",
          "autofocus"   => true,
          "keyup"       => handleKeys
        ])
      ]);
  }

  function handleKeys(e : KeyboardEvent) {
    e.preventDefault();
    if(Keys.ENTER != e.which) return;
    var value = getInputValue();
    trace("input", value);
    if(value.isEmpty()) return;
    prop.add(value);
  }

  function getInputValue() {
    var el : InputElement = cast element.querySelector("input");
    untyped __js__("console.log")(element);
    return el.value;
  }
}

typedef AddToDoItem = {
  public function add(label : String) : Void;
}
