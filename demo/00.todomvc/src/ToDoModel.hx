import thx.ReadonlyArray;
using thx.Functions;

class ToDoModel {
  public var length(default, null) : Int;
  public var filter(default, null) : ToDoFilter;
  public var filteredItems(default, null) : ReadonlyArray<ToDoItemModel>;
  public var onUpdate : Void -> Void;
  var allItems : Array<ToDoItemModel>;

  public function new() {
    filter = All;
    allItems = [
      { label : "something todo", completed : false },
      { label : "something else", completed : false },
      { label : "this is done", completed : true }
    ];
    onUpdate = function() {};
    update();
  }

  public function setFilter(filter : ToDoFilter) {
    this.filter = filter;
    update();
  }

  public function add(label : String) {
    allItems.push({ label : label, completed : false});
    update();
  }

  public function remove(item : ToDoItemModel) {
    allItems.remove(item);
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
}
