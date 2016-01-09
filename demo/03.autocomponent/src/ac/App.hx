package ac;

import Doom.*;

class App extends Doom {
  override function render()
    return div(["class" => "my-app"], [
      new AutoButton({ click: onClick }, {}, "Click me"),
      new AutoWidget({}, { title: "My title", subTitle: "My subtitle", content: "My content", footer: "My footer" }),
    ]);

  function onClick() : Void
    trace('button click');
}
