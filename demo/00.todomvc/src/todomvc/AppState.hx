package todomvc;

import thx.ReadonlyArray;

typedef AppState = {
  items : ReadonlyArray<ItemData>,
  countActive : Int,
  countTotal : Int
}
