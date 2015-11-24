package todomvc.util;

import todomvc.data.TodoItem;
import todomvc.data.VisibilityFilter;
import thx.ReadonlyArray;
using thx.Arrays;
using thx.Functions;

class Filters {
  public static function filterVisibility(arr : ReadonlyArray<TodoItem>, filter : VisibilityFilter)
    return switch filter {
      case ShowAll:
        arr.copy();
      case ShowActive:
        arr.filter.fn(!_.completed);
      case ShowCompleted:
        arr.filter.fn(_.completed);
    };
}
