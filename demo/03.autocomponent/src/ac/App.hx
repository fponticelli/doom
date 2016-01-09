package ac;

import Doom.*;

class App extends Doom {
  override function render()
    return div(["class" => "my-app"], [
      AutoButton.create(onClick, "Click me"),
      AutoWidget.create("My title", "My content", {
        subTitle: "My subtitle",
        footer: "My footer"
      }),
    ]);

  function onClick() : Void
    trace('button click');
}
