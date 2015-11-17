import thx.Nil;
import doom.Component;
import js.Browser.*;
import doom.Node.*;
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
      document.getElementById("content"));
  }
}

class Todo extends Component<TodoListData> {
  public function addTodo(description : String) {
    state.items.push({ checked : false, description : description });
    update(state);
  }

  public function removeCompleted() {
    state.items = state.items.filter(function(item) return !item.checked);
    update(state);
  }

  override function render() {
    return el("div",
      ["class" => "todo"], [
        comp(new TodoList(state)),
        comp(new TodoForm(addTodo, removeCompleted, nil))
      ]
    );
  }
}

class TodoList extends Component<TodoListData> {
  override function render() {
    if(state.items.length == 0) {
      return el("div", "no need to do anything at all");
    } else {
      return el("ul",
        [for(item in state.items)
          el("li", [comp(new TodoItem(item))])
        ]
      );
    }
  }
}

class TodoForm extends Component<Nil> {
  var addTodo : String -> Void;
  var removeCompleted : Void -> Void;
  public function new(addTodo : String -> Void, removeCompleted : Void -> Void, state : Nil) {
    super(state);
    this.addTodo = addTodo;
    this.removeCompleted = removeCompleted;
  }

  override function render() {
    return el("form", [
        "submit" => onSubmit
      ], [
        el("input", [
          "placeholder" => "add a new todo here",
          "value" => ""
        ]),
        el("div", [
          el("a", [
            "href" => "#"
          ], [
            "click" => onClickRemoveCompleted
          ], "remove completed")
        ])
      ]
    );
  }

  function onClickRemoveCompleted(e : js.html.Event) {
    e.preventDefault();
    removeCompleted();
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
  override function render() {
    return el("label", [
      el("input", [
        "type" => "checkbox",
        "checked" => (state.checked ? "true" : null)
      ], [
        "change" => onCheckChange
      ]),
      el("span", [
        "class" => (state.checked ? "done" : null)
      ], state.description)
    ]);
  }

  function onCheckChange(_) {
    state.checked = !state.checked;
    update(state);
  }
}

typedef TodoListData = {
  items : Array<TodoItemData>
}

typedef TodoItemData = {
  checked : Bool,
  description : String
}
