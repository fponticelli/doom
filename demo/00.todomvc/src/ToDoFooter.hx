import doom.Component;
import doom.Html.*;
import doom.Node;
import thx.ReadonlyArray;
using thx.Functions;

class ToDoFooter extends Component<FooterState> {
  override function render() {
    return FOOTER(["class" => "footer"], [
        SPAN([
            "class" => "todo-count"
          ],
          getItemsLeftLabel()
        ),
        UL(["class" => "filters"], [
          LI(A(["class" => ["selected" => true],  "href" => "#"], "All")),
          LI(A(["class" => ["selected" => false], "href" => "#/active"], "Active")),
          LI(A(["class" => ["selected" => false], "href" => "#/completed"], "Completed"))
        ]),
        BUTTON(["class" => "clear-completed"], "Clear completed")
      ]);
  }

  function getItemsLeft()
    return state.items.filter.fn(!_.completed).length;

  function getItemsLeftLabel() : Array<Node> {
    var left = getItemsLeft();
    return left == 1 ? [STRONG("1"), " item left"] : [STRONG('$left'), " items left"];
  }
}

typedef FooterState = {
  items : ReadonlyArray<ToDoItemModel>
}
