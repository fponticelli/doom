import dots.Query;
import fs.App;

class Main {
  static function main() {
    var api = new fs.AppApi("vegetables.json");
    Doom.mount(
      new App(api, api.state),
      Query.first("section.fs")
    );
  }
}
