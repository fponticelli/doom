package doom;

import js.html.Element;
using doom.Patch;

class ApiComponent<Api, State> extends Component<State> {
  public var api : Api;
  public function new(api : Api, state : State) {
    this.api = api;
    super(state);
  }
}
