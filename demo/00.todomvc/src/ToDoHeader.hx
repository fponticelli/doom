import doom.PropertiesStatelessComponent;
import doom.Html.*;
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
    var value = getInputValueAndEmpty();
    if(value.isEmpty()) return;
    prop.add(value);
  }

  function getInputValueAndEmpty() {
    var el : InputElement = cast element.querySelector("input"),
        value = el.value;
    el.value = "";
    return value;
  }
}

typedef AddToDoItem = {
  public function add(label : String) : Void;
}
