package auto;

import Doom.*;
import doom.*;
import js.html.*;

enum AutoButtonStyle {
  Default;
  Primary;
  Secondary;
}

class AutoButton implements AutoComponent {
  @:state
  public var intValue : Int;

  @:state(123)
  public var intValueOpt : Int;

  @:state
  public var stringValue : String;

  @:state("test")
  public var stringValueOpt : String;

  @:state
  public var enumValue : AutoButtonStyle;

  @:state(Primary)
  public var enumValueOpt : AutoButtonStyle;

  @:api
  public var voidApi : Void -> Void;

  @:api(null)
  public var voidApiOpt : Void -> Void;

  @:api
  public var elementApi : ButtonElement -> Void;

  @:api(null)
  public var elementApiOpt : ButtonElement -> Void;

  @:api
  public var eventApi : MouseEvent -> Void;

  @:api(null)
  public var eventApiOpt : MouseEvent -> Void;

  /*
  public override function render() : Node {
    return button([
    ], children);
  }
  */
}
