package todomvc;

import thx.ReadonlyArray;
using thx.Arrays;
using thx.Functions;
using thx.Strings;
import haxe.Json;
import js.Browser.*;

class AppProperties {
  public var countActive(default, null) : Int;
  public var countTotal(default, null) : Int;
  public var filter(default, null) : Filter;
  public var filteredItems(default, null) : ReadonlyArray<ItemData>;
  public var onUpdate : Void -> Void;
  var allItems : Array<ItemData>;

  public function new() {
    filter = All;
    allItems = load();
    onUpdate = function() {};
    refresh();
  }

  public function setFilter(filter : Filter) {
    this.filter = filter;
    refresh();
  }

  public function add(label : String) {
    allItems.push({ label : label, completed : false});
    save();
    refresh();
  }

  public function remove(item : ItemData) {
    allItems.remove(item);
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
      case All:
        filteredItems = allItems.copy();
      case Active:
        filteredItems = allItems.filter.fn(!_.completed);
      case Completed:
        filteredItems = allItems.filter.fn(_.completed);
    }
    countActive = allItems.filter.fn(!_.completed).length;
    countTotal = allItems.length;
    onUpdate();
  }

  static inline var STORAGE_KEY : String = "TodoMVC-Doom";
  public function save() {
    window.localStorage.setItem(STORAGE_KEY, Json.stringify(allItems));
  }

  function load() {
    var v = window.localStorage.getItem(STORAGE_KEY);
    if(v.hasContent())
      return Json.parse(v);
    else
      return [];
  }
}
