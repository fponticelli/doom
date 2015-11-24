package todomvc.view;

import Doom.*;
import doom.PropertiesComponent;
import js.html.KeyboardEvent;
import js.html.InputElement;
import todomvc.data.TodoItem;
using thx.Strings;

class Item extends PropertiesComponent<ItemProperties, ItemState> {
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
          "change"  => handleChecked
        ]),
        LABEL(state.item.text),
        BUTTON([
          "class" => "destroy",
          "click" => handleRemove
        ])
      ]),
      INPUT([
        "class" => "edit",
        "value" => state.item.text,
        "blur"  => handleBlur,
        "keyup" => handleKeydown,
      ])
    ]);

  function handleChecked(checked : Bool) {
    state.item.completed = checked;
    prop.save();
    prop.refresh();
  }

  function handleRemove() {
    prop.remove(state.index);
  }

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
      handleRemove();
    } else {
      state.item.text = value;
      prop.save();
      update(state);
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

typedef ItemProperties = {
  public function remove(index : Int) : Void;
  public function refresh() : Void;
  public function save() : Void;
}

typedef ItemState = {
  index : Int,
  item : TodoItem,
  editing : Bool
}
