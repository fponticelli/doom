import utest.Assert;
import thx.stream.Stream;
using thx.stream.StreamExtensions;

typedef SampleState = {
  count: Int
}

enum SampleAction {
  Increment;
  Decrement;
  Sum(x: Int);
}

class TestPlayGround {
  public function new() {}

  public function testBasics() {
    var f = Doom3.stream(reducer, render);
    f({ count: 1 })
      .zip(Stream.values([1,2,3]))
      .log()
      .next(function(s) {
        Assert.equals('count: ${s.right}', s.left);
      })
      .done(Assert.createAsync())
      .run();
  }

  public static function reducer(action: SampleAction, state: SampleState)
    return switch action {
      case Increment: { count: state.count + 1 };
      case Decrement: { count: state.count - 1 };
      case Sum(x): { count: state.count + x };
    };

  public static function render(state: SampleState, dispatch: SampleAction -> Void) {
    thx.Timer.delay(dispatch.bind(Increment), 1);
    return Stream.value('count: ${state.count}');
  };
}

typedef Render<State, Node> = State -> Node;

typedef SubscribeRender<State, Node> = State -> Stream<Node>;

typedef Dispatch<Action> = Action -> Void;

class Doom3 {
  public static function stream<Action, State, Node>(
      reducer: Action -> State -> State,
      render: State -> Dispatch<Action> -> Stream<Node>
    ): State -> Stream<Node> {
    return function(state: State) {
      return Stream.create(function(obs) {
        function run(state: State) {
          try {
            var dispatch = function(action: Action) run(reducer(action, state));
            render(state, dispatch)
              .next(function(v) obs.message(Next(v))) // TODO it ignores done
              .failure(function(v) obs.message(Error(v)))
              .run();
          } catch(e: Dynamic) {
            obs.message(Error(thx.Error.fromDynamic(e)));
          }
        }
        // dispatch =
        run(state);
      });
    };
  }
}
