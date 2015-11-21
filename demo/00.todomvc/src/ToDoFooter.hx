import doom.PropertiesComponent;
import doom.Html.*;
import doom.Node;
import thx.ReadonlyArray;
using thx.Functions;

class ToDoFooter extends PropertiesComponent<FooterProp, FooterState> {
  override function render() {
    var footerContent = [
        SPAN([
            "class" => "todo-count"
          ],
          getItemsLeftLabel()
        ),
        UL(["class" => "filters"], [
          LI(A([
            "class" => [
              "selected" => isFilter(All)
            ],
            "href" => "#",
            "click" => handleClickFilter.bind(All)
          ], "All")),
          LI(A([
            "class" => [
              "selected" => isFilter(Active)
            ],
            "href" => "#/active",
            "click" => handleClickFilter.bind(Active)
          ], "Active")),
          LI(A([
            "class" => [
              "selected" => isFilter(Completed)
            ],
            "href" => "#/completed",
            "click" => handleClickFilter.bind(Completed)
          ], "Completed"))
        ])
      ];
    if(state.hasCompleted) {
      footerContent.push(
        BUTTON([
          "class" => "clear-completed",
          "click" => handleClear
        ], "Clear completed")
      );
    }
    return FOOTER(["class" => "footer"], footerContent);
  }

  function handleClear() {
    prop.clearCompleted();
  }

  function handleClickFilter(filter : ToDoFilter) {
    prop.setFilter(filter);
  }

  function isFilter(filter : ToDoFilter)
    return Type.enumEq(state.filter, filter);

  function getItemsLeftLabel() : Array<Node> {
    return state.countActive == 1 ? [STRONG("1"), " item left"] : [STRONG('${state.countActive}'), " items left"];
  }
}

typedef FooterProp = {
  public function setFilter(filter : ToDoFilter) : Void;
  public function clearCompleted() : Void;
}

typedef FooterState = {
  countActive : Int,
  filter : ToDoFilter,
  hasCompleted : Bool
}
