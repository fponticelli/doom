import dots.Query;
import todomvc.view.App;
import todomvc.data.AppState;
import todomvc.data.TodoAction;
import todomvc.data.VisibilityFilter;
import todomvc.data.Reducers.*;
import lies.Store;
import js.Browser.*;
import haxe.Json;
using thx.Strings;

class Main {
  static inline var STORAGE_KEY : String = "TodoMVC-Doom";
  static function main() {
    var store = Store.create(todoApp, {
      visibilityFilter : getFilterFromHash(),
      todos : getTodosFromLocalStorage()
    });

    // save changes to local storage
    store.subscribe(function(state : AppState) {
      window.localStorage.setItem(STORAGE_KEY, Json.stringify(state.todos));
    });

    // set filter in hash
    store.subscribe(function(state : AppState) {
      window.location.hash = switch state.visibilityFilter {
        case ShowActive: "/active";
        case ShowCompleted: "/completed";
        case _: "";
      };
    });

    // log to console
    store.subscribe(function(action : TodoAction) {
      console.log(thx.Enums.string(action));
    });

    // init app
    Doom.mount(
      new App(store),
      Query.first("section.todoapp")
    );
  }

  static function getFilterFromHash() {
    var hash = window.location.hash.trimCharsLeft("#");
    return switch hash {
      case "/active": ShowActive;
      case "/completed": ShowCompleted;
      case _: ShowAll;
    };
  }

  static function getTodosFromLocalStorage() {
    var v = window.localStorage.getItem(STORAGE_KEY);
    if(v.hasContent())
      return Json.parse(v);
    else
      return [];
  }
}
