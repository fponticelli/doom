package todomvc.view;

import todomvc.data.VisibilityFilter;
import todomvc.data.TodoItem;
import thx.ReadonlyArray;

typedef AppState = {
  items : ReadonlyArray<TodoItem>,
  remaining : Int,
  complete : Int,
  filter : VisibilityFilter
}
