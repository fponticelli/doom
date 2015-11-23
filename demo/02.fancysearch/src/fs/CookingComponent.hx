package fs;

import Doom.*;
import doom.PropertiesComponent;
import haxe.ds.Option;

class CookingComponent extends PropertiesComponent<String, String> {
  override function render() {
    return TR([
            TH(prop),
            TD([state, " min."])
          ]);
  }
}
