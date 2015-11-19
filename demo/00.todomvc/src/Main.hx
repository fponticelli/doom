import dots.Query;
import doom.Component;

class Main {
  static function main() {
    Component.mount(
      new ToDoApp(new ToDoModel()),
      Query.first("section.todoapp")
    );
  }
}
