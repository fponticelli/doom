import dots.Query;
import todomvc.AppProperties;
import todomvc.App;

class Main {
  static function main() {
    var prop = new AppProperties();
    Doom.mount(
      new App(prop, {
        items       : prop.filteredItems,
        countActive : prop.countActive,
        countTotal  : prop.countTotal
      }),
      Query.first("section.App")
    );
  }
}
