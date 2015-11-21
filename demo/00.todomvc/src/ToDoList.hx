import doom.PropertiesComponent;
import doom.Html.*;
import thx.ReadonlyArray;
using thx.Arrays;
using thx.Functions;

class ToDoList extends PropertiesComponent<ToDoController, ToDoListState> {
  override function render()
    return SECTION(["class" => "main"], [
      INPUT([
        "class" => "toggle-all",
        "type" => "checkbox",
        "checked" => state.allCompleted,
        "change" => prop.toggleCheck
      ]),
      LABEL(["for" => "toggle-all"], "Mark all as complete"),
      UL(["class" => "todo-list"], [
        for(item in state.items) new ToDoItem(prop, { item : item, editing : false })
      ])
    ]);
}

typedef ToDoListState = {
  items : ReadonlyArray<ToDoItemModel>,
  allCompleted : Bool
}
