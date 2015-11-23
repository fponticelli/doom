package fs;

import Doom.*;
import doom.Component;

class VeggieComponent extends Component<Veggie> {
  override function render() {
    return LI(state.vegetable);
  }
}
