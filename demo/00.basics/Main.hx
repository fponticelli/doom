import thx.Nil;
import doom.Component;
import js.Browser.*;
import doom.Node.*;
import dots.Query;
using dots.Attribute;
using thx.Arrays;
using thx.Strings;

class Main {
  public static function main() {
    Component.mount(new Todo({ items : [
      {
        checked : false,
        description : "brush teeth"
      }, {
        checked : false,
        description : "pee"
      }, {
        checked : true,
        description : "take shower"
      }
      ]}),
      Query.first(".todoapp")
    );
  }
}

class Todo extends Component<TodoListData> {
  function addTodo(description : String) {
    state.items.push({ checked : false, description : description });
    update(state);
  }

  function removeCompleted() {
    state.items = state.items.filter(function(item) return !item.checked);
    update(state);
  }

  function deleteItem(item : TodoItemData) {
    state.items.remove(item);
    update(state);
  }

  function refresh() {
    update(state);
  }

  function toggleChecked() {
    var value = !allSelected();
    state.items.each(function(item) return item.checked = value);
    update(state);
  }

  function allSelected()
    return state.items.all(function(item) return item.checked);

  override function render() {
    return el("div",
      [
        comp(new TodoForm(addTodo, nil)),
        comp(new TodoList(refresh, toggleChecked, deleteItem, state)),
        comp(new TodoFooter(nil))
      ]
    );
  }
}

class TodoFooter extends Component<Nil> {
  override function render() {
    return el("footer", ["class" => "footer"], [
      el("span", ["class" => "todo-count"], [
        el("strong", "777"),
        text(" items left")
      ]),
      el("ul", ["class" => "filters"], [
        el("li", [
          el("a", ["href" => "#", "class" => "selected"], "All")
        ]),
        el("li", [
          el("a", ["href" => "#/active", "class" => "selected"], "Active")
        ]),
        el("li", [
          el("a", ["href" => "#/completed", "class" => "selected"], "Completed")
        ])
      ]),
      el("button", ["class" => "clear-completed"],
        "Clear completed"
      )
    ]);
  }
/*
<footer class="footer" style="display: block;">
  <span class="todo-count"><strong>3</strong> items left</span>
  <ul class="filters">
    <li>
    <a href="#/" class="selected">All</a>
    </li>
    <li>
    <a href="#/active">Active</a>
    </li>
    <li>
    <a href="#/completed">Completed</a>
    </li>
  </ul>
  <button class="clear-completed" style="display: block;">Clear completed</button>
</footer>
*/
}

class TodoList extends Component<TodoListData> {
  var deleteItem : TodoItemData -> Void;
  var refresh : Void -> Void;
  var toggleChecked : Void -> Void;
  public function new(refresh : Void -> Void, toggleChecked : Void -> Void, deleteItem : TodoItemData -> Void, state : TodoListData) {
    this.refresh = refresh;
    this.deleteItem = deleteItem;
    this.toggleChecked = toggleChecked;
    super(state);
  }
  override function render() {
    if(state.items.length == 0) {
      return empty();
    } else {
      return el("section", [
        "class" => "main"
      ], [
        el("input", [
            "class" => "toggle-all",
            "type" => "checkbox",
            "checked" => allSelected(),
            "change" => onToggleAll
          ]
        ),
        el("label", [
          "for" => "toggle-all"],
          "Mark all as complete"),
        el("ul",
          ["class" => "todo-list"],
          [for(item in state.items)
            comp(new TodoItem(refresh, deleteItem, item))
          ]
        )
      ]);
    }
  }

  function onToggleAll(_) {
    toggleChecked();
  }

  function allSelected()
    return state.items.all(function(item) return item.checked);
}

class TodoForm extends Component<Nil> {
  var addTodo : String -> Void;
  public function new(addTodo : String -> Void, state : Nil) {
    super(state);
    this.addTodo = addTodo;
  }

  override function render() {
    return el("header", ["class" => "header"], [
      el("h1", "todos"),
      el("form", [
        "submit" => onSubmit
      ], [
        el("input", [
          "placeholder" => "What needs to be done?",
          "class" => "new-todo"
        ])
      ])
    ]);
  }

  function onSubmit(e : js.html.Event) {
    e.preventDefault();
    var input : js.html.InputElement = cast (cast e.target : js.html.Element).querySelector("input");
    var value = input.value;
    if(value.isEmpty())
      return;
    input.value = "";
    addTodo(value);
  }
}

class TodoItem extends Component<TodoItemData> {
  var deleteItem : TodoItemData -> Void;
  var refresh : Void -> Void;
  public function new(refresh : Void -> Void, deleteItem : TodoItemData -> Void, state : TodoItemData) {
    this.refresh = refresh;
    this.deleteItem = deleteItem;
    super(state);
  }

  override function render() {
    return el("li", [
      "class" => ["completed" => state.checked, "editing" => state.editing == true].asAttribute()
    ], [
      el("div", ["class" => "view"], [
        el("input", [
          "class" => "toggle",
          "type" => "checkbox",
          "checked" => state.checked,
          "change" => onCheckChange
        ]),
        el("label", [
            "dblclick" => onDoubleClick
          ],
          state.description
        ),
        el("button", [
          "class" => "destroy",
          "click" => onDelete,
        ])
      ]),
      el("input", [
        "class" => "edit",
        "value" => state.description,
        "blur" => onSubmit,
        "keydown" => onKeyDown
      ])
    ]);
  }

  function onCheckChange(_) {
    state.checked = !state.checked;
    refresh();
  }

  function onDoubleClick(_) {
    state.editing = !state.editing;
    refresh();
  }

  function onDelete(_) {
    deleteItem(state);
  }

  function onSubmit(_) {

  }

  function onChange(input : js.html.InputElement) {

  }

  function onKeyDown(e : js.html.KeyboardEvent) {
    trace(e.which);
    if (e.which == 9) {
      state.editing = !state.editing;
      refresh();
    } else if (e.which == 13) {
      onSubmit(e);
    }
  }
}

typedef TodoListData = {
  items : Array<TodoItemData>
}

typedef TodoItemData = {
  checked : Bool,
  description : String,
  ?editing : Bool
}
