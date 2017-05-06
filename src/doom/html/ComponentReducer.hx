package doom.html;

import doom.core.VNodes;
import thx.stream.Property;
import thx.stream.Store;
import thx.stream.Reducer.Middleware;

class ComponentReducer<Action, Props> extends doom.html.Component<Props> {
  public var dispatch(default, null): Action -> Void;
  public function new(
    property: Property<Props>,
    reducer: Props -> Action -> Props,
    ?middleware: Middleware<Props, Action>,
    ?children: VNodes
  ) {
    var store = new Store(property, reducer, middleware);
    dispatch = function(v) store.dispatch(v);
    store.stream().message(function(msg) switch msg {
      case Next(v): update(v);
      case Error(e): throw 'unrecoverable error $e';
      case Done: // enough is enough
    }).run();
    super(property.get(), children);
  }
}
