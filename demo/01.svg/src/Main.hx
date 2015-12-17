import dots.Query;
import svg.SvgApp;

class Main {
  static function main() {
    Doom.mount(
      new SvgApp({}, {}),
      Query.find("section.svg")
    );
  }
}
