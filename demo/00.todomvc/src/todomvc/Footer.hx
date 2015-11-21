package todomvc;

import doom.PropertiesComponent;
import Doom.*;
import doom.Node;

class Footer extends PropertiesComponent<FooterProp, FooterState> {
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

  function handleClear()
    prop.clearCompleted();

  function handleClickFilter(filter : Filter)
    prop.setFilter(filter);

  function isFilter(filter : Filter)
    return Type.enumEq(state.filter, filter);

  function getItemsLeftLabel() : Array<Node>
    return state.countActive == 1 ? [STRONG("1"), " item left"] : [STRONG('${state.countActive}'), " items left"];
}

typedef FooterProp = {
  public function setFilter(filter : Filter) : Void;
  public function clearCompleted() : Void;
}

typedef FooterState = {
  countActive : Int,
  filter : Filter,
  hasCompleted : Bool
}
