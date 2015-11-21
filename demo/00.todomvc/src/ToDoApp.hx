import doom.PropertiesComponent;
import doom.HTML.*;
import thx.ReadonlyArray;

class ToDoApp extends PropertiesComponent<ToDoController, ReadonlyArray<ToDoItemModel>> {
  override function render() {
    return DIV([
      new ToDoHeader(prop),
      new ToDoBody(prop, state)
    ]);
  }
}

class ToDoBody extends PropertiesComponent<ToDoController, ReadonlyArray<ToDoItemModel>> {
  public function new(prop : ToDoController, state : ReadonlyArray<ToDoItemModel>) {
    super(prop, state);
    prop.onUpdate = function() update(prop.filteredItems);
  }

  override function render() {
    return if(state.length == 0) {
      empty();
    } else {
      DIV([
        new ToDoList(prop, state),
        new ToDoFooter()
      ]);
    };
  }
}
