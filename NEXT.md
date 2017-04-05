```haxe
typedef Render<State, Node> = State -> Node;

typedef SubscribeRender<State, Node> = State -> Stream<Node>;

typedef Dispatch<Action> = Action -> Void;

function reduceRender<Action, State, Node>(
    reduce: Action -> State -> State,
    render: State -> Dispatch<Action> -> Node
  ): State -> Stream<Node> {
  return function(state: State) {
    return Stream.create(function(obs) {
      function run(state: State) {
        try {
          var node = render(state, dispatch);
          obs.message(Next(node));
        } catch(e: Dynamic) {
          obs.message(Error(thx.Error.fromDynamic(e)));
        }
      }
      function dispatch(action: Action) {
        state = reduce(action, state); // mutation ?!
        run(state);
      };
      run(state);
    });
  };
}
```
