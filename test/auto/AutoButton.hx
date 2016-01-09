package auto;

import js.html.*;
import Doom.*;
import doom.*;

enum AutoButtonStyle {
  Default;
  Primary;
  Secondary;
}

@:children(opt) // nothing=opt or req|opt|none
class AutoButton extends AutoComponent {
  @:state // nothing=req or req|opt|literal value
  public var intValue : Int;

  @:state(opt)
  public var intValueOpt : Null<Int>;

  @:state(123)
  public var intValueDef : Int;

  @:state
  public var stringValue : String;

  @:state(opt)
  public var stringValueOpt : Null<String>;

  @:state("test")
  public var stringValueDef : String;

  @:state
  public var enumValue : AutoButtonStyle;

  @:state(opt)
  public var enumValueOpt : Null<AutoButtonStyle>;

  @:state(Primary)
  public var enumValueDef : AutoButtonStyle;

  @:api
  public var voidApi : Void -> Void;

  @:api(opt)
  public var voidApiOpt : Void -> Void;

  @:api
  public var elementApi : ButtonElement -> Void;

  @:api(opt)
  public var elementApiOpt : ButtonElement -> Void;

  @:api
  public var eventApi : MouseEvent -> Void;

  @:api(opt)
  public var eventApiOpt : MouseEvent -> Void;

  public override function render() : Node {
    return button([
      "type" => "button"
    ], children);
  }
}
