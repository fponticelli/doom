package todomvc.data;

import thx.ReadonlyArray;

typedef AppState = {
  visibilityFilter : VisibilityFilter,
  todos : ReadonlyArray<TodoItem>
}
