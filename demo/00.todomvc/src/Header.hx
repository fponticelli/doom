import doom.PropertiesStatelessComponent;
import Doom.*;
import dots.Keys;
import js.html.*;
using thx.Strings;

class Header extends PropertiesStatelessComponent<AddItem> {
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
    var value = getInputValueAndEmpty();
    if(value.isEmpty()) return;
    prop.add(value);
  }

  function getInputValueAndEmpty() {
    var el : InputElement = cast element.querySelector("input"),
        value = el.value.trim();
    el.value = "";
    return value;
  }
}

typedef AddItem = {
  public function add(label : String) : Void;
}
