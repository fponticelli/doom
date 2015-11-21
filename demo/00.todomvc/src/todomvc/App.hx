package todomvc;

import Doom.*;
import doom.PropertiesComponent;
import thx.ReadonlyArray;

class App extends PropertiesComponent<AppProperties, AppState> {
  override function render()
    return DIV([
      new Header(prop),
      new Body(prop, state)
    ]);
}
