import thx.Nil;
import thx.Timer;
import doom.View;
import js.Browser.*;
using doom.Node;
import doom.Node.*;

class Main {
  public static function main() {
    new Dashboard(document.getElementById("content"), { counter : 0 });
  }
}

class Dashboard extends View<DashboardModel> {
  var state : DashboardModel;
  var cancel : Void -> Void = function() {};
  function startCount(_) {
    trace("Start");
    cancel = Timer.repeat(function() {
      state.counter++;
      update(state);
    }, 50);
  }

  function stopCount(_) {
    cancel();
    cancel = function() {};
  }

  override function render(state : DashboardModel) {
    this.state = state;
    return el("div",
      [
        el("div", 'count: ${state.counter}'),
        el("div", [
          el("button", ["click" => startCount], "start count"),
          el("button", ["click" => stopCount],  "stop count")
        ])
      ]
    );
  }
}

typedef DashboardModel = {
  counter : Int
}
