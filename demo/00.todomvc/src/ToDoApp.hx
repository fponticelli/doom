import doom.Component;
import doom.Node.*;
import thx.Nil;

class ToDoApp extends Component<ToDoModel> {
  public function new(state : ToDoModel) {
    super(state);
    state.onUpdate = function() {
      update(state);
    };
  }

  override function render() {
    var header = new ToDoHeader(nil);
    return if(state.length == 0) {
      el("div", [
        header
      ]);
    } else {
      el("div", [
        header,
        new ToDoList(state),
        new ToDoFooter(nil)
      ]);
    };
  }
}
