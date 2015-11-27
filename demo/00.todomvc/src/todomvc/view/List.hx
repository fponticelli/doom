package todomvc.view;

import Doom.*;
import doom.ApiComponent;
import thx.ReadonlyArray;
import todomvc.data.TodoItem;
import todomvc.data.VisibilityFilter;

class List extends ApiComponent<ListApi, ListState> {
  override function render()
    return SECTION(["class" => "main"], [
      INPUT([
        "class" => "toggle-all",
        "type" => "checkbox",
        "checked" => state.allCompleted,
        "change" => api.toggleAll
      ]),
      LABEL(["for" => "toggle-all"], "Mark all as complete"),
      UL(["class" => "todo-list"], [
        for(i in 0...state.items.length)
          new Item({
            remove : api.remove.bind(i),
            toggle : api.toggle.bind(i),
            updateText : api.updateText.bind(i, _)
          }, {
            item : state.items[i],
            editing : false
          })
      ])
    ]);
}



typedef ListApi = {
  function setFilter(filter : VisibilityFilter) : Void;
  function clearCompleted() : Void;
  function toggleAll() : Void;
  function remove(index : Int) : Void;
  function updateText(index : Int, text : String) : Void;
  function toggle(index : Int) : Void;
}

typedef ListState = {
  items : ReadonlyArray<TodoItem>,
  allCompleted : Bool
}
