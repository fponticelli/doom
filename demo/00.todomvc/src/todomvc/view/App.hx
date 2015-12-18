package todomvc.view;

import Doom.*;
import doom.Component;
import lies.Store;
import thx.ReadonlyArray;
import todomvc.data.AppState;
import todomvc.data.TodoAction;
import todomvc.data.VisibilityFilter;

class App extends Component<Store<AppState, TodoAction>, {}> {
  override function render() {
    var header = new Header({
          add : function(text) api.dispatch(Add(text))
        }, {}),
        body = new Body({
          setFilter : function(filter : VisibilityFilter)
            api.dispatch(SetVisibilityFilter(filter)),
          clearCompleted : function()
            api.dispatch(ClearCompleted),
          remove : function(id : String)
            api.dispatch(Remove(id)),
          toggle : function(id : String)
            api.dispatch(Toggle(id)),
          toggleAll : function()
            api.dispatch(ToggleAll),
          updateText : function(id : String, text : String)
            api.dispatch(UpdateText(id, text)),
        }, api.state);
    api.subscribe(function() {
      body.update(api.state);
    });
    return div([header, body]);
  }
}
