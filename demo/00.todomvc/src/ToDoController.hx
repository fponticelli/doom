import thx.ReadonlyArray;
using thx.Functions;
using thx.Strings;
import haxe.Json;
import js.Browser.*;

class ToDoController {
  public var length(default, null) : Int;
  public var filter(default, null) : ToDoFilter;
  public var filteredItems(default, null) : ReadonlyArray<ToDoItemModel>;
  public var onUpdate : Void -> Void;
  var allItems : Array<ToDoItemModel>;

  public function new() {
    filter = All;
    allItems = load();
    onUpdate = function() {};
    update();
  }

  public function setFilter(filter : ToDoFilter) {
    this.filter = filter;
    update();
  }

  public function add(label : String) {
    trace("add", label);
    allItems.push({ label : label, completed : false});
    save();
    update();
  }

  public function remove(item : ToDoItemModel) {
    allItems.remove(item);
    save();
    update();
  }

  function update() {
    switch filter {
      case All:
        filteredItems = allItems.copy();
      case Active:
        filteredItems = allItems.filter.fn(_.completed);
      case Completed:
        filteredItems = allItems.filter.fn(!_.completed);
    }
    length = filteredItems.length;
    onUpdate();
  }

  static inline var STORAGE_KEY : String = "TodoMVC-Doom";
  function save() {
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
