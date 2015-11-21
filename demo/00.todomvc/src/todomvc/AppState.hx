package todomvc;

import thx.ReadonlyArray;

typedef AppState = {
  items : ReadonlyArray<ItemData>,
  remaining : Int,
  complete : Int,
  filter : Filter
}
