package todomvc.view;

import Doom.*;
import doom.ApiStatelessComponent;
import lies.Store;
import thx.ReadonlyArray;
import todomvc.data.AppState;
import todomvc.data.TodoAction;
import todomvc.data.VisibilityFilter;

class App extends ApiStatelessComponent<Store<AppState, TodoAction>> {
  override function render() {
    var header = new Header({
          add : function(text) api.dispatch(Add(text))
        }),
        body = new Body({
          setFilter : function(filter : VisibilityFilter)
            api.dispatch(SetVisibilityFilter(filter)),
          clearCompleted : function()
            api.dispatch(ClearCompleted),
          remove : function(index : Int)
            api.dispatch(Remove(index)),
          toggle : function(index : Int)
            api.dispatch(Toggle(index)),
          toggleAll : function()
            api.dispatch(ToggleAll),
          updateText : function(index : Int, text : String)
            api.dispatch(UpdateText(index, text)),
        }, api.state);
    api.subscribe(function() {
      body.update(api.state);
    });
    return DIV([header, body]);
  }
}
