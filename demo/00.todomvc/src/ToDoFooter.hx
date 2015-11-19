import doom.Component;
import doom.Node.*;
import thx.Nil;

class ToDoFooter extends Component<Nil> {
  override function render() {
    return el("footer", ["class" => "footer"], [
        el("span", [
          "class" => "todo-count"
        ], [
          el("strong", "0"),
          "item left"
        ]),
        el("ul", ["class" => "filters"], [
          el("li", el("a", ["class" => ["selected" => true], "href" => "#"], "All")),
          el("li", el("a", ["class" => ["selected" => false], "href" => "#/active"], "Active")),
          el("li", el("a", ["class" => ["selected" => false], "href" => "#/completed"], "Completed"))
        ]),
        el("button", ["class" => "clear-completed"], "Clear completed")
      ]);
  }
}
