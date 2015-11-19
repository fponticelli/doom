import doom.Component;
import doom.Node.*;
import thx.Nil;

class ToDoList extends Component<ToDoModel> {
  override function render() {
    return el("section", ["class" => "main"], [
      el("input", ["class" => "toggle-all", "type" => "checkbox"]),
      el("label", ["for" => "toggle-all"], "Mark all as complete"),
      el("ul", ["class" => "todo-list"], [
        for(item in state.filteredItems) new ToDoItem(item)
      ])
    ]);
  }
}
