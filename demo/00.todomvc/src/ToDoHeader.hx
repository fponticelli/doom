import doom.Component;
import doom.Node.*;
import thx.Nil;

class ToDoHeader extends Component<Nil> {
  override function render() {
    return el("header", [
        "class" => "header"
      ], [
        el("h1", "todos"),
        el("input", [
          "class"       => "new-todo",
          "placeholder" => "What needs to be done?",
          "autofocus"   => true
        ])
      ]);
    // <header class="header">
    //   <h1>todos</h1>
    //   <input class="new-todo" placeholder="What needs to be done?" autofocus>
    // </header>
  }
}
