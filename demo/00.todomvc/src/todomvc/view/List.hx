package todomvc.view;

import Doom.*;
import doom.PropertiesComponent;
import thx.ReadonlyArray;
import todomvc.data.TodoItem;
import todomvc.data.VisibilityFilter;

class List extends PropertiesComponent<ListProperties, ListState> {
  override function render()
    return SECTION(["class" => "main"], [
      INPUT([
        "class" => "toggle-all",
        "type" => "checkbox",
        "checked" => state.allCompleted,
        "change" => prop.toggleAll
      ]),
      LABEL(["for" => "toggle-all"], "Mark all as complete"),
      UL(["class" => "todo-list"], [
        for(i in 0...state.items.length)
          new Item({
            remove : prop.remove.bind(i),
            toggle : prop.toggle.bind(i),
            updateText : prop.updateText.bind(i, _)
          }, {
            item : state.items[i],
            editing : false
          })
      ])
    ]);
}



typedef ListProperties = {
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
