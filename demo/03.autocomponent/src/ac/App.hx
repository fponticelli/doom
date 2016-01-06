package ac;

import Doom.*;
import doom.*;

class App extends Component<AppApi, AppState> {
  public override function render() : Node {
    return div(["class" => "my-app"], [
      new AutoButton(onClick, Default, { size: Large }, "Click me").render()
    ]);
  }

  function onClick() : Void {
    trace('button click');
  }
}
