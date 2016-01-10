import dots.Query;
import ac.App;

class Main {
  static function main() {
    Doom.mount(App.with(), Query.find("#root"));
  }
}
