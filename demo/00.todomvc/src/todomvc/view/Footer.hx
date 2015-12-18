package todomvc.view;

import todomvc.data.VisibilityFilter;
import doom.Component;
import Doom.*;
import doom.Node;

class Footer extends Component<FooterApi, FooterState> {
  override function render() {
    var footerContent = [
        span([
            "class" => "todo-count"
          ],
          getItemsLeftLabel()
        ),
        ul(["class" => "filters"], [
          li(a([
            "class" => [
              "selected" => isFilter(ShowAll)
            ],
            "href" => "#",
            "click" => handleClickFilter.bind(ShowAll)
          ], "All")),
          li(a([
            "class" => [
              "selected" => isFilter(ShowActive)
            ],
            "href" => "#/active",
            "click" => handleClickFilter.bind(ShowActive)
          ], "Active")),
          li(a([
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
        button([
          "class" => "clear-completed",
          "click" => handleClear
        ], "Clear completed")
      );
    }
    return footer(["class" => "footer"], footerContent);
  }

  function handleClear()
    api.clearCompleted();

  function handleClickFilter(filter : VisibilityFilter)
    api.setFilter(filter);

  function isFilter(filter : VisibilityFilter)
    return Type.enumEq(state.filter, filter);

  function getItemsLeftLabel() : Array<Node>
    return state.remaining == 1 ? [strong("1"), " item left"] : [strong('${state.remaining}'), " items left"];
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
