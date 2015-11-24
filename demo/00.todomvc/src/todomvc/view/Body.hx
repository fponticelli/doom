package todomvc.view;

import Doom.*;
import doom.PropertiesComponent;
import thx.ReadonlyArray;

class Body extends PropertiesComponent<AppProperties, AppState> {
  public function new(prop : AppProperties, state : AppState) {
    super(prop, state);
    prop.onUpdate = function() update({
      items : prop.filteredItems,
      remaining : prop.remaining,
      complete : prop.complete,
      filter : prop.filter
    });
  }

  override function render()
    return if(state.complete == 0) {
      dummy("nothing to do yet");
    } else {
      DIV([
        new List(prop, {
          items : state.items,
          allCompleted : state.remaining == 0
        }),
        new Footer(prop, {
          remaining : state.remaining,
          filter : state.filter,
          hasCompleted : state.complete - state.remaining > 0
        })
      ]);
    };
}
