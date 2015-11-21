import dots.Query;
import doom.Component;

class Main {
  static function main() {
    var controller = new ToDoController();
    Component.mount(
      new ToDoApp(controller, {
        items : controller.filteredItems,
        countActive : controller.countActive,
        countTotal : controller.countTotal
      }),
      Query.first("section.todoapp")
    );
  }
}
