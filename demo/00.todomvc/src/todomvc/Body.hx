package todomvc;

import Doom.*;
import doom.PropertiesComponent;
import thx.ReadonlyArray;

class Body extends PropertiesComponent<AppProperties, AppState> {
  public function new(prop : AppProperties, state : AppState) {
    super(prop, state);
    prop.onUpdate = function() update({
      items : prop.filteredItems,
      countActive : prop.countActive,
      countTotal : prop.countTotal
    });
  }

  override function render() {
    return if(state.countTotal == 0) {
      dummy("nothing to do yet");
    } else {
      DIV([
        new List(prop, {
          items : state.items,
          allCompleted : state.countActive == 0
        }),
        new Footer(prop, {
          countActive : state.countActive,
          filter : prop.filter,
          hasCompleted : state.countTotal - state.countActive > 0
        })
      ]);
    };
  }
}
