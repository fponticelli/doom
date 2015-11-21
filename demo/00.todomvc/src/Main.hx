import dots.Query;
import todomvc.AppProperties;
import todomvc.App;

class Main {
  static function main() {
    var prop = new AppProperties();
    Doom.mount(
      new App(prop, {
        items     : prop.filteredItems,
        remaining : prop.remaining,
        complete  : prop.complete,
        filter    : prop.filter
      }),
      Query.first("section.todoapp")
    );
  }
}
