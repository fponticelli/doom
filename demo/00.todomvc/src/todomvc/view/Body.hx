package todomvc.view;

import Doom.*;
import doom.ApiComponent;
import todomvc.data.AppState;
using todomvc.data.VisibilityFilter;

class Body extends ApiComponent<BodyApi, AppState> {
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
  function remove(index : Int) : Void;
  function updateText(index : Int, text : String) : Void;
  function toggle(index : Int) : Void;
  function toggleAll() : Void;
}
