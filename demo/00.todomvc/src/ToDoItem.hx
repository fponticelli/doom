import doom.PropertiesComponent;
import doom.HTML.*;

class ToDoItem extends PropertiesComponent<RemoveItemController, ToDoItemModel> {
  override function render() {
    return LI([
        "class" => [
          "completed" => state.completed,
          "edit" => false
        ]
      ], [
      DIV(["class" => "view"], [
        INPUT([
          "class" => "toggle",
          "type" => "checkbox",
          "checked" => state.completed,
          "change" => handleChecked
        ]),
        LABEL(state.label),
        BUTTON([
          "class" => "destroy",
          "click" => handleRemove
        ])
      ]),
      INPUT([
        "class"  => "edit",
        "value"  => state.label
      ])
    ]);
  }

  function handleChecked(el : js.html.InputElement) {
    state.completed = el.checked;
    update(state);
  }

  function handleRemove() {
    prop.remove(state);
  }
}

typedef RemoveItemController = {
  public function remove(item : ToDoItemModel) : Void;
}
