package todomvc.view;

import todomvc.data.VisibilityFilter;
import todomvc.data.TodoItem;
import haxe.Json;
import js.Browser.*;
import thx.ReadonlyArray;
using thx.Arrays;
using thx.Functions;
using thx.Strings;

class AppProperties {
  static inline var STORAGE_KEY : String = "TodoMVC-Doom";

  public var remaining(default, null) : Int;
  public var complete(default, null) : Int;
  public var filter(default, null) : VisibilityFilter;
  public var filteredItems(default, null) : ReadonlyArray<TodoItem>;
  public var onUpdate : Void -> Void;
  var allItems : Array<TodoItem>;

  public function new() {
    filter = getFilterFromHash();
    allItems = load();
    onUpdate = function() {};
    refresh();
  }

  public function setFilter(filter : VisibilityFilter) {
    this.filter = filter;
    assignFilterToHash(filter);
    refresh();
  }

  public function add(text : String) {
    allItems.push({ text : text, completed : false});
    save();
    refresh();
  }

  public function remove(index : Int) {
    allItems.splice(index, 1);
    save();
    refresh();
  }

  public function clearCompleted() {
    allItems = allItems.filter.fn(!_.completed);
    save();
    refresh();
  }

  public function toggleCheck() {
    var completed = allItems.all.fn(_.completed);
    allItems.each.fn(_.completed = !completed);
    refresh();
  }

  public function refresh() {
    switch filter {
      case ShowAll:
        filteredItems = allItems.copy();
      case ShowActive:
        filteredItems = allItems.filter.fn(!_.completed);
      case ShowCompleted:
        filteredItems = allItems.filter.fn(_.completed);
    }
    remaining = allItems.filter.fn(!_.completed).length;
    complete = allItems.length;
    onUpdate();
  }

  public function save() {
    window.localStorage.setItem(STORAGE_KEY, Json.stringify(allItems));
  }

  public function getFilterFromHash() : VisibilityFilter {
    var hash = window.location.hash.trimCharsLeft("#");
    return switch hash {
      case "/active": ShowActive;
      case "/completed": ShowCompleted;
      case _: ShowAll;
    };
  }

  public function assignFilterToHash(filter : VisibilityFilter) {
    window.location.hash = switch filter {
      case ShowActive : "/active";
      case ShowCompleted : "/completed";
      case ShowAll: "";
    };
  }

  function load() {
    var v = window.localStorage.getItem(STORAGE_KEY);
    if(v.hasContent())
      return Json.parse(v);
    else
      return [];
  }
}
