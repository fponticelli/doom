package fs;

import Doom.*;
import doom.PropertiesComponent;

class App extends PropertiesComponent<AppProperties, AppState> {
  public function new(prop : AppProperties, state : AppState) {
    super(prop, state);
    prop.onUpdate = function() {
      update(prop.state);
    };
    thx.Timer.immediate(prop.load);
  }

  override function render() {
    return DIV(["class" => "fancy-container"], [
      H1("veggies cooking time"),
      comp(new SearchItem(state))
    ]);
  }
}
