# Doom

## Vitual Dom Library for Haxe

[TodoMVC Demo](https://rawgit.com/fponticelli/doom/master/demo/00.todomvc/index.html)

[SVG support](https://rawgit.com/fponticelli/doom/master/demo/01.svg/www/index.html)

[AutoComponent macro](https://rawgit.com/fponticelli/doom/master/demo/03.autocomponent/www/index.html)

## Components

TODO

## AutoComponents

You can also create a `Component` by extending the special `doom.AutoComponent`
base class.  This class has a Haxe `@:autoBuild` macro which will generate
a lot of the State/Api/etc. boilerplate code that is typically needed for
Components.

The extending class should use metadata params on the class and fields
to provide information about the children, state, and api capabilities
of the Component.

### Class-level metadata

#### `@:children`

Defines whether the component has no children, required
children, or optional children (Nodes).

- `@:children(opt)` - denotes that the component has optional children
- `@:children(req)` - denotes that the component has required children
- `@:children(none)` - denotes that the component has no children (e.g. input or br elements)
- If not specified, the default is `@:children(opt)`

### Field-level metadata

#### `@:state`

State fields must currently be defined as `var`s in the class (not
properties).

- `@:state` - denotes a required state field
- `@:state(opt)` - denotes an optional state field with no default value
- `@:state(value)` - denotes an optional state field with default value `value`.  `value` must match the var's type.

#### `@:api`

API fields must be defined as `var`s in the class (not functions or
properties).

- `@:api` - denotes a required api field
- `@:api(opt)` - denotes an optional api field

### Example AutoComponent class:

```haxe
package my.components;

import Doom.*;
import doom.*;

@:children(opt) // this component has optional children
class MyButton extends AutoComponent {
  @:state // required state field
  public var style : String;

  @:state("btn-lg") // optional state field (defaults to "btn-lg" if not provided by the caller)
  public var size : String;

  @:api // required api field
  public var click : Void -> Void;

  @:api(opt) // optional api field
  public var hover : Void -> Void;

  // don't define constructor - it will be generated

  // don't define static create function - generated

  // don't define update/shouldRender functions - generated

  // define the render function as usual (using member state/api vars)
  override function render() : Node {
    return button([
      "type" => "button",
      "class" => '$style $size',
      "click" => click,
      "hover" => hover
    ], children);
  }
}
```

Result of AutoComponent @:autoBuild macro:

```haxe
// Generated state structure (in same package as component)
package my.components;

typedef MyButtonState = {
  style : String,
  ?size : String
};

// Generate api structure (in same package as component)
package my.components;

typedef MyButtonApi = {
  click: Void -> Void,
  ?hover: Void -> Void
};

// Modified component class
class MyButton extends AutoComponent {
  // added state/api/children fields
  public var state : MyButtonState;
  public var api : MyButtonApi;
  public var children : Null<Nodes>;

  // fields changed to properties
  public var style(get, null) : String;
  public var size(get, null) : String;
  public var click(get, null) : Void -> Void;
  public var hover(get, null) : Void -> Void;

  // generated (inline) getters for state/api
  inline function get_style() : String {
    return state.style;
  }

  inline function get_size() : String {
    return state.size;
  }

  inline function get_click() : Void -> Void {
    return api.click;
  }

  inline function get_hover() : Void -> Void {
    return api.hover;
  }

  // generated constructor
  public function new(api : MyButtonApi, state: MyButtonState, ?children : Nodes) {
    if (state.size == null) state.size = "btn-lg";
    this.api = api;
    this.state = state;
    this.children = children;
    super();
  }

  // generated static create function
  /* not yet implemented
  public static function create(
    click : Void -> Void,
    ?optApi : { ?hover : Void -> Void },
    style : String,
    ?optState : { ?size : String },
    ?children : Nodes) : MyButton {
    // TODO
    return new MyButton({
      style: style,
      size: size
    }, {
    }, children);
  }
  */

  // generated update function
  public function update(newState : MyButtonState) : Void {
    var oldState = this.state;
    this.state = newState;
    if (!shouldRender(oldState, newState)) return;
    updateNode(node);
  }

  // generated shouldRender function (if not provided above)
  public function shouldRender(oldState : MyButtonState, newState : MyButtonState) : Bool {
    return true;
  }

  // render function unchanged
  public function render() : Node {
    // same code as above
  }
}
```
