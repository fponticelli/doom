package todomvc.view;

import todomvc.data.VisibilityFilter;
import thx.ReadonlyArray;

typedef AppState = {
  items : ReadonlyArray<ItemData>,
  remaining : Int,
  complete : Int,
  filter : VisibilityFilter
}
