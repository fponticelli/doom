package todomvc.data;

import thx.ReadonlyArray;
using thx.Arrays;
using thx.Functions;

enum VisibilityFilter {
  ShowAll;
  ShowCompleted;
  ShowActive;
}

class VisibilityFilters {
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
