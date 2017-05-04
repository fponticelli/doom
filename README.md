# Doom

Doom is a Virtual Dom Library for Haxe. It is strictly typed (no `Dynamic`s
lurking around) and built to be easy to use.

## Examples

  To see easy examples, please look at the folder `examples` from this repository.

## Demos

  * [TodoMVC Demo](https://rawgit.com/fponticelli/doom/master/demo/todomvc/index.html)
  * [SVG support](https://rawgit.com/fponticelli/doom/master/demo/svg/www/index.html)
  * [Doom Auto Component macro](https://rawgit.com/fponticelli/doom/master/demo/autocomponent/www/index.html)

## VNode

A `VNode` (virtual node) is the basic rendering element in Doom. It can
represent an element (like a `DIV` or an `A`), simple text or a Component.

Generating a `VNode` doesn't automatically render it. A `VNode` needs to be
translated into browser DOM nodes. There are two ways to do that:

  * mount the `VNode` directly in the DOM
  * generate and return a `VNode` from a `Component.render` method.

To mount a `VNode` use `Doom.render.mount()`:

```haxe
import doom.html.Html.*;
import js.Browser.document as doc;

class Main {
  static function main()
    Doom.browser.mount(
      h1("I'm just a simple element"),
      doc.getElementById("main")
    );
}
```

### VNode Types

The following `VNode` types exist:

  * `Element(name: String, attributes: Map<String, AttributeValue>, children: VNodes)`
  * `Comment(comment: String)`
  * `Raw(code: String)`
  * `Text(text: String)`
  * `Comp<Props, El>(comp: Component<Props, El>)`

These can be generated using the homonymous methods on `doom.core.VNode`, `doom.html.Html` and/or `doom.html.Svg` (the last two are convenient aliases). The methods are `el`, `comp`, `comment`, `raw` and `text`. `doom.html.Html` also contains shortcut methods like `div` or `input` to generate equivalent
nodes.

### VNodes

Most elements accept child elements, there are typed as `VNodes` which is an abstract on `Array<VNode>` with a few additional benefits (mostly implicit cast from common types).

### AttributeValue

Elements expect a `Map<String, AttributeValue>` to set the node attributes and properties. `AttributeValue` is a convenient abstract that simplifies assigning the right values to the attributes.

`AttributeValue` has 3 constructors:

  * `BoolAttribute(b : Bool)`
  * `StringAttribute(s : String)`
  * `EventAttribute<T : Event>(f : T -> Void)`

Here are the types that are implicitly converted to `AttributeValue`:

  * `String` for attributes like `id` or `class`
  * `Map<String, Bool>` mainly to be used with `class`. It is convenient to turn
    on and off class names:

```haxe
div([
  "class" => [
    "button" => true,
    "active" => props.active,
    style    => null != style
  ]
]);
```

  * `Bool` used with attributes like `disabled` or `checked`
  * `Void -> Void` an event handler that doesn't care about information
    related to the even itself. `click` is the perfect example for it.
  * `(T : Event) -> Void` when you want an event handler and have full control
    on the `Event` object.
  * `(T : Element) -> Void`, the handler receives the original element that
    triggered the event.
  * `String -> Void`, the handler receives the text content of the element
    that triggered the event. The text content is retrieved in different ways
    according to the type of element (`input`, `textarea`, `select`, ...).
  * `Bool -> Void`, the handler receives a flag value from the `checked`
    attribute.
  * `Int -> Void`, works like `String -> Void` but tries to convert the value
    into an `Int`. If that cannot happen the handler is not invoked.
  * `Float -> Void`, same as `Int -> Void` but for floats.

*Note*: All event handlers except for `(T : Event) -> Void` will automatically
call `event.preventDefault()`.

## Components

A component is anything between a full UI application and a button. A component
lives inside another component (as a VNode returned by the `render` method) or it can be mounted directly in the dom.

```haxe
import doom.html.Component;
import doom.html.Html.*;
using thx.Objects;
import thx.Timer;

class Main {
  static function main() {
    var div = js.Browser.document.getElementById("main");
    Doom.browser.mount(new BannerComponent({
      messages : [ "Doom", "is", "Magic", "(but the good kind)" ],
      delay : 500,
      toDisplay : 0
    }), div);
  }
}

class BannerComponent extends Component<BannerProps> {
  override function render() {
    Timer.delay(function() {
      update(props.shallowMerge({
        toDisplay : (props.toDisplay + 1) % props.messages.length
      }));
    }, props.delay);
    return h1(props.messages[props.toDisplay]);
  }
}

typedef BannerProps = {
  messages : Array<String>,
  delay : Int,
  toDisplay : Int
}
```

  * TODO describe update
  * TODO describe api
  * TODO describe state
