package doom;

import js.html.Element;
using doom.Patch;

class PropertiesComponent<Properties, State> extends Component<State> {
  public var prop : Properties;
  public function new(prop : Properties, state : State) {
    this.prop = prop;
    super(state);
  }
}
