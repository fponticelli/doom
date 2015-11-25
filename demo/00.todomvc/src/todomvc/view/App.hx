package todomvc.view;

import Doom.*;
import doom.PropertiesStatelessComponent;
import lies.Store;
import thx.ReadonlyArray;
import todomvc.data.AppState;
import todomvc.data.TodoAction;
import todomvc.data.VisibilityFilter;

class App extends PropertiesStatelessComponent<Store<AppState, TodoAction>> {
  override function render() {
    var header = new Header({
          add : function(text) prop.dispatch(Add(text))
        }),
        body = new Body({
          setFilter : function(filter : VisibilityFilter)
            prop.dispatch(SetVisibilityFilter(filter)),
          clearCompleted : function()
            prop.dispatch(ClearCompleted),
          remove : function(index : Int)
            prop.dispatch(Remove(index)),
          toggle : function(index : Int)
            prop.dispatch(Toggle(index)),
          toggleAll : function()
            prop.dispatch(ToggleAll),
          updateText : function(index : Int, text : String)
            prop.dispatch(UpdateText(index, text)),
        }, prop.state);
    prop.subscribe(function() {
      body.update(prop.state);
    });
    return DIV([header, body]);
  }
}
