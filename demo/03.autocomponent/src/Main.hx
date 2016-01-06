import dots.Query;
import ac.App;

class Main {
  static function main() {
    Doom.mount(new App({}, {}), Query.find("#root"));
  }
}
