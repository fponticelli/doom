package fs;

import Doom.*;
import doom.PropertiesComponent;
import doom.Node;
import thx.ReadonlyArray;
using thx.Functions;
using thx.Strings;

class List extends PropertiesComponent<{ listener : String -> Void }, ReadonlyArray<Veggie>> {
  public function new(prop, state) {
    super(prop, state);
    prop.listener = function(f) {
      f = f.toLowerCase();
      update(state.filter(function(i) return i.vegetable.toLowerCase().contains(f)));
    };
  }
  override function render() {
    return SECTION([
        UL(state.map(function(v) : Node return new VeggieComponent(v)))
      ]);
  }

  function handleSelectionChange(_, s : String) {
    trace(s);
  }
}
