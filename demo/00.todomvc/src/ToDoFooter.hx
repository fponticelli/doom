import doom.StatelessComponent;
import doom.Html.*;

class ToDoFooter extends StatelessComponent {
  override function render() {
    return FOOTER(["class" => "footer"], [
        SPAN([
          "class" => "todo-count"
        ], [
          STRONG("0"), " item left"
        ]),
        UL(["class" => "filters"], [
          LI(A(["class" => ["selected" => true], "href" => "#"], "All")),
          LI(A(["class" => ["selected" => false], "href" => "#/active"], "Active")),
          LI(A(["class" => ["selected" => false], "href" => "#/completed"], "Completed"))
        ]),
        BUTTON(["class" => "clear-completed"], "Clear completed")
      ]);
  }
}
