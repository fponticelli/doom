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
        for(item in state.items)
          new Item({
            remove : api.remove.bind(item.id),
            toggle : api.toggle.bind(item.id),
            updateText : api.updateText.bind(item.id, _)
          }, {
            item : item,
            editing : false
          })
      ])
    ]);
}



typedef ListApi = {
  function setFilter(filter : VisibilityFilter) : Void;
  function clearCompleted() : Void;
  function toggleAll() : Void;
  function remove(id : String) : Void;
  function updateText(id : String, text : String) : Void;
  function toggle(id : String) : Void;
}

typedef ListState = {
  items : ReadonlyArray<TodoItem>,
  allCompleted : Bool
}
