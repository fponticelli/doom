package fs;

import Doom.*;
import doom.ApiComponent;
import haxe.ds.Option;

class CookingComponent extends ApiComponent<String, String> {
  override function render() {
    return TR([
            TH(api),
            TD([state, " min."])
          ]);
  }
}
