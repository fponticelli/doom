package todomvc.view;

import Doom.*;
import doom.Component;
import js.html.KeyboardEvent;
import todomvc.data.TodoItem;
using thx.Strings;

class Item extends Component<ItemApi, ItemState> {
  override function render()
    return li([
        "class" => [
          "completed" => state.item.completed,
          "editing"   => state.editing,
        ],
        "dblclick" => handleDblClick
      ], [
      div(["class" => "view"], [
        input([
          "class"   => "toggle",
          "type"    => "checkbox",
          "checked" => state.item.completed,
          "change"  => api.toggle
        ]),
        label(state.item.text),
        button([
          "class" => "destroy",
          "click" => api.remove
        ])
      ]),
      input([
        "class" => "edit",
        "value" => state.item.text,
        "blur"  => handleBlur,
        "keyup" => handleKeydown,
      ])
    ]);

  function handleDblClick() {
    state.editing = true;
    update(state);
    getInput().select();
  }

  function handleBlur() {
    if(!state.editing) return;
    state.editing = false;
    var value = getInputValueAndTrim();
    if(value.isEmpty()) {
      api.remove();
    } else if(value != state.item.text) {
      api.updateText(value);
    } else {
      update({ item : state.item, editing : false });
    }
  }

  function handleKeydown(e : KeyboardEvent) {
    if(e.which != dots.Keys.ENTER)
      return;
    handleBlur();
  }

  function getInput() : js.html.InputElement
    return cast element.querySelector("input.edit");

  function getInputValueAndTrim() {
    var input = getInput();
    return input.value = input.value.trim();
  }
}

typedef ItemApi = {
  public function remove() : Void;
  public function toggle() : Void;
  public function updateText(text : String) : Void;
}

typedef ItemState = {
  item : TodoItem,
  editing : Bool
}
