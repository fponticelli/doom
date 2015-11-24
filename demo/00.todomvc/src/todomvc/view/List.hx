package todomvc.view;

import Doom.*;
import doom.PropertiesComponent;
import thx.ReadonlyArray;

class List extends PropertiesComponent<AppProperties, ListState> {
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
        for(i in 0...state.items.length)
          new Item(prop, { item : state.items[i], index : i, editing : false })
      ])
    ]);
}

typedef ListState = {
  items : ReadonlyArray<ItemData>,
  allCompleted : Bool
}
