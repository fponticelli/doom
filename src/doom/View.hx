package doom;

import js.html.Node as DomNode;
import js.html.Element as DomElement;
import doom.Node;
using doom.Patch;

class View<State> extends Component<State> {
  public function new(ref : DomElement, state : State) {
    super(state);
    ref.innerHTML = "";
    init();
    ref.appendChild(element);
  }
}
