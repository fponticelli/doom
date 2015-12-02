package fs;

import Doom.*;
import doom.Component;
import haxe.ds.Option;

class CookingComponent extends Component<String, String> {
  override function render() {
    return TR([
            TH(api),
            TD([state, " min."])
          ]);
  }
}
