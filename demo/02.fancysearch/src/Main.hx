import dots.Query;
import fs.App;

class Main {
  static function main() {
    var properties = new fs.AppProperties("vegetables.json");
    Doom.mount(
      new App(properties, properties.state),
      Query.first("section.fs")
    );
  }
}
