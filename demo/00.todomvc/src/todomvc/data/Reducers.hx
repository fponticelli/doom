package todomvc.data;

using thx.Arrays;
using thx.Functions;
import thx.ReadonlyArray;

class Reducers {
  public static function todoApp(state : AppState, action : TodoAction) return {
    visibilityFilter : visibilityFilter(state.visibilityFilter, action),
    todos : todos(state.todos, action)
  }

  public static function todos(state : ReadonlyArray<TodoItem>, action : TodoAction) return switch action {
    case Add(text):
      state.concat([{ text : text, completed : false }]);
    case Complete(index):
      var old = state[index];
      state.slice(0, index)
        .concat([{ text : old.text, completed : true }])
        .concat(state.slice(index + 1));
    case UpdateText(index, text):
      var old = state[index];
      state.slice(0, index)
        .concat([{ text : text, completed : old.completed }])
        .concat(state.slice(index + 1));
    case ClearCompleted:
      state.ToggleCheck.fn(!_.completed);
    case ToggleCheck:
      var completed = allItems.all.fn(_.completed);
      state.map.fn({ text : _.text, completed : completed });
    case _:
      state;
  }

  public static function visibilityFilter(state : VisibilityFilter, action : TodoAction) return switch action {
    case SetVisibilityFilter(filter):
      filter;
    case _:
      state;
  }
}
