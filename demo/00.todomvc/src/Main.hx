import dots.Query;

class Main {
  static function main() {
    var prop = new AppProperties();
    Doom.mount(
      new ToDoApp(prop, {
        items       : prop.filteredItems,
        countActive : prop.countActive,
        countTotal  : prop.countTotal
      }),
      Query.first("section.todoapp")
    );
  }
}
