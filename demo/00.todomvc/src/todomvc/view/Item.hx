package todomvc.view;

import Doom.*;
import doom.ApiComponent;
import js.html.KeyboardEvent;
import todomvc.data.TodoItem;
using thx.Strings;

class Item extends ApiComponent<ItemApi, ItemState> {
  override function render()
    return LI([
        "class" => [
          "completed" => state.item.completed,
          "editing"   => state.editing,
        ],
        "dblclick" => handleDblClick
      ], [
      DIV(["class" => "view"], [
        INPUT([
          "class"   => "toggle",
          "type"    => "checkbox",
          "checked" => state.item.completed,
          "change"  => api.toggle
        ]),
        LABEL(state.item.text),
        BUTTON([
          "class" => "destroy",
          "click" => api.remove
        ])
      ]),
      INPUT([
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
