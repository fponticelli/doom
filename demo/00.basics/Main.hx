import thx.Nil;
import thx.Timer;
import doom.View;
import doom.Component;
import js.Browser.*;
using doom.Node;
import doom.Node.*;

class Main {
  public static function main() {
    new Todo(document.getElementById("content"), { items : [] });
  }
}

class Todo extends View<TodoListModel> {
  public function appendItem(description : String) {

  }

  public function removeChecked() {

  }

  public function setTodoValues(todo : TodoItemModel) {

  }

  override function render() {
    return el("div",
      ["class" => "todo"],
      [
        comp(new TodoList(state)),
        comp(new TodoForm(nil))
      ]
    );
  }
}

class TodoList extends Component<TodoListModel> {
  override function render() {
    return Empty;
  }
}

class TodoForm extends Component<Nil> {
  override function render() {
    return Empty;
  }
}

class TodoItem extends Component<TodoItemModel> {
  override function render() {
    return Empty;
  }
}

/*
class Like extends View<LikeModel> {
  override function render() {
    var text = state.liked ? 'like' : "haven't liked";
    return el("p",
      ["click" => handleClick.bind(_, state.liked)],
      'You $text this. Click to toggle.'
    );
  }

  function handleClick(_, liked)
    update({ liked : !liked});
}
*/

typedef TodoListModel = {
  items : Array<TodoItemModel>
}

typedef TodoItemModel = {
  checked : Bool,
  description : String
}
