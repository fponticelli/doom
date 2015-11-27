package todomvc.view;

import todomvc.data.VisibilityFilter;
import doom.ApiComponent;
import Doom.*;
import doom.Node;

class Footer extends ApiComponent<FooterApi, FooterState> {
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
              "selected" => isFilter(ShowAll)
            ],
            "href" => "#",
            "click" => handleClickFilter.bind(ShowAll)
          ], "All")),
          LI(A([
            "class" => [
              "selected" => isFilter(ShowActive)
            ],
            "href" => "#/active",
            "click" => handleClickFilter.bind(ShowActive)
          ], "Active")),
          LI(A([
            "class" => [
              "selected" => isFilter(ShowCompleted)
            ],
            "href" => "#/completed",
            "click" => handleClickFilter.bind(ShowCompleted)
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
    api.clearCompleted();

  function handleClickFilter(filter : VisibilityFilter)
    api.setFilter(filter);

  function isFilter(filter : VisibilityFilter)
    return Type.enumEq(state.filter, filter);

  function getItemsLeftLabel() : Array<Node>
    return state.remaining == 1 ? [STRONG("1"), " item left"] : [STRONG('${state.remaining}'), " items left"];
}

typedef FooterApi = {
  function setFilter(filter : VisibilityFilter) : Void;
  function clearCompleted() : Void;
}

typedef FooterState = {
  remaining : Int,
  filter : VisibilityFilter,
  hasCompleted : Bool
}
