package todomvc.view;

import Doom.*;
import doom.Component;
import todomvc.data.AppState;
using todomvc.data.VisibilityFilter;

class Body extends Component<BodyApi, AppState> {
  override function render()
    return if(state.todos.length == 0) {
      dummy("nothing to do yet");
    } else {
      var all = state.todos.length,
          completed = state.todos.filterVisibility(ShowCompleted).length,
          remaining = all - completed;
      DIV([
        new List(api, {
          items : state.todos.filterVisibility(state.visibilityFilter),
          allCompleted : completed == 0
        }),
        new Footer(api, {
          remaining : remaining,
          filter : state.visibilityFilter,
          hasCompleted : completed > 0
        })
      ]);
    };
}

typedef BodyApi = {
  function setFilter(filter : VisibilityFilter) : Void;
  function clearCompleted() : Void;
  function remove(id : String) : Void;
  function updateText(id : String, text : String) : Void;
  function toggle(id : String) : Void;
  function toggleAll() : Void;
}
