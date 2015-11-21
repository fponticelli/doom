package todomvc;

import doom.PropertiesComponent;
import Doom.*;
import thx.ReadonlyArray;
using thx.Arrays;
using thx.Functions;

class ToDoList extends PropertiesComponent<AppProperties, ToDoListState> {
  override function render()
    return SECTION(["class" => "main"], [
      INPUT([
        "class" => "toggle-all",
        "type" => "checkbox",
        "checked" => state.allCompleted,
        "change" => prop.toggleCheck
      ]),
      LABEL(["for" => "toggle-all"], "Mark all as complete"),
      UL(["class" => "todo-list"], [
        for(item in state.items) new Item(prop, { item : item, editing : false })
      ])
    ]);
}

typedef ToDoListState = {
  items : ReadonlyArray<ItemData>,
  allCompleted : Bool
}
