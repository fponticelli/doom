package fs;

import Doom.*;
import doom.ApiComponent;

class App extends ApiComponent<AppApi, AppState> {
  public function new(api : AppApi, state : AppState) {
    super(api, state);
    api.onUpdate = function() {
      update(api.state);
    };
    thx.Timer.immediate(api.load);
  }

  override function render() {
    return DIV(["class" => "fancy-container"], [
      H1("veggies cooking time"),
      comp(new SearchItem(state))
    ]);
  }
}
