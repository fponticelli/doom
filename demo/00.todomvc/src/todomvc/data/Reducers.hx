package todomvc.data;

using thx.Arrays;
using thx.Functions;
using thx.Objects;
import thx.ReadonlyArray;
import thx.Uuid;

class Reducers {
  public static function todoApp(state : AppState, action : TodoAction) return {
    visibilityFilter : visibilityFilter(state.visibilityFilter, action),
    todos : todos(state.todos, action)
  }

  public static function todos(state : ReadonlyArray<TodoItem>, action : TodoAction) return switch action {
    case Add(text):
      state
        .concat([{ id : Uuid.create(), text : text, completed : false }]);
    case Toggle(id):
      var index = getIndex(state, id);
      state.slice(0, index)
        .concat([state[index].merge({ completed : !state[index].completed })])
        .concat(state.slice(index + 1));
    case Remove(id):
      var index = getIndex(state, id);
      state.slice(0, index)
        .concat(state.slice(index + 1));
    case UpdateText(id, text):
      var index = getIndex(state, id);
      state.slice(0, index)
        .concat([state[index].merge({ text : text })])
        .concat(state.slice(index + 1));
    case ClearCompleted:
      state.filter.fn(!_.completed);
    case ToggleAll:
      var completed = !state.all.fn(_.completed);
      state.map.fn({ id : _.id, text : _.text, completed : completed });
    case _:
      state;
  }

  static function getIndex(items : ReadonlyArray<TodoItem>, id : String) : Int
    return items.findIndex(function(item) return item.id == id);

  public static function visibilityFilter(state : VisibilityFilter, action : TodoAction) return switch action {
    case SetVisibilityFilter(filter):
      filter;
    case _:
      state;
  }
}
