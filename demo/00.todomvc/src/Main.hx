import dots.Query;
import todomvc.view.App;
import todomvc.data.VisibilityFilter;
import todomvc.data.Reducers.*;
import lies.Store;
import js.Browser.*;
import haxe.Json;
using thx.Strings;

class Main {
  static inline var STORAGE_KEY : String = "TodoMVC-Doom";
  static function main() {
    var store = new Store(function(state, action) {
      trace(thx.Enums.string(action));
      return todoApp(state, action);
    }, {
      visibilityFilter : getFilterFromHash(),
      todos : getTodosFromLocalStorage()
    });

    // save changes to local storage
    store.subscribe(function() {
      window.localStorage.setItem(STORAGE_KEY, Json.stringify(store.getState().todos));
    });

    // set filter in hash
    store.subscribe(function() {
      window.location.hash = switch store.getState().visibilityFilter {
        case ShowActive: "/active";
        case ShowCompleted: "/completed";
        case _: "";
      };
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
