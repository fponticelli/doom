import dots.Query;
import doom.Component;

class Main {
  static function main() {
    var controller = new ToDoController();
    Component.mount(
      new ToDoApp(controller, controller.filteredItems),
      Query.first("section.todoapp")
    );
  }
}
