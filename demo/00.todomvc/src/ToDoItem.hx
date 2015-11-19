import doom.Component;
import doom.Node.*;

class ToDoItem extends Component<ToDoItemModel> {
  override function render() {
    return el("li", [
        "class" => [
          "completed" => state.completed,
          "edit" => false
        ]
      ], [
      el("div", ["class" => "view"], [
        el("input", [
          "class" => "toggle",
          "type" => "checkbox",
          "checked" => state.completed
        ]),
        el("label", state.label),
        el("button", ["class" => "destroy"])
      ]),
      el("input", [
        "class" => "edit",
        "value" => state.label
      ])
    ]);
  }
}
