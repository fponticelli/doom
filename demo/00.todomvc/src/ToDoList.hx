import doom.PropertiesComponent;
import doom.Html.*;
import thx.ReadonlyArray;

class ToDoList extends PropertiesComponent<ToDoController, ReadonlyArray<ToDoItemModel>> {
  override function render() {
    return SECTION(["class" => "main"], [
      INPUT(["class" => "toggle-all", "type" => "checkbox"]),
      LABEL(["for" => "toggle-all"], "Mark all as complete"),
      UL(["class" => "todo-list"], [
        for(item in state) new ToDoItem(prop, item)
      ])
    ]);
  }
}
