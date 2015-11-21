import doom.PropertiesComponent;
import doom.Html.*;
import thx.ReadonlyArray;

class ToDoApp extends PropertiesComponent<ToDoController, ToDoAppState> {
  override function render() {
    return DIV([
      new ToDoHeader(prop),
      new ToDoBody(prop, state)
    ]);
  }
}

class ToDoBody extends PropertiesComponent<ToDoController, ToDoAppState> {
  public function new(prop : ToDoController, state : ToDoAppState) {
    super(prop, state);
    prop.onUpdate = function() update({
      items : prop.filteredItems,
      countActive : prop.countActive,
      countTotal : prop.countTotal
    });
  }

  override function render() {
    return if(state.countTotal == 0) {
      dummy("nothing to do yet");
    } else {
      DIV([
        new ToDoList(prop, {
          items : state.items,
          allCompleted : state.countActive == 0
        }),
        new ToDoFooter(prop, {
          countActive : state.countActive,
          filter : prop.filter,
          hasCompleted : state.countTotal - state.countActive > 0
        })
      ]);
    };
  }
}

typedef ToDoAppState = {
  items : ReadonlyArray<ToDoItemModel>,
  countActive : Int,
  countTotal : Int
}
