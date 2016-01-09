package ac;

import Doom.*;
import doom.*;

class App extends Component<AppApi, AppState> {
  public override function render() : Node {
    return div(["class" => "my-app"], [
      new AutoButton({ click: onClick }, {}, "Click me"),
      new AutoWidget({}, { title: "My title", subTitle: "My subtitle", content: "My content", footer: "My footer" }),
    ]);
  }

  function onClick() : Void {
    trace('button click');
  }
}
