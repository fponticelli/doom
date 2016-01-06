package ac;

import Doom.*;
import doom.*;

enum AutoButtonStyle {
  Default;
  Primary;
  Secondary;
  Info;
  Warning;
  Danger;
  Success;
}

enum AutoButtonSize {
  Default;
  Large;
  Small;
}

class AutoButton implements AutoComponent {
  @:state
  public var style : AutoButtonStyle;

  @:state(Default)
  public var size : AutoButtonSize;

  @:api
  public var click : Void -> Void;

  public function render() : Node {
    return button([
      "type" => "button",
      "class" => 'btn ${getStyleClass()}, ${getSizeClass()}',
      "click" => click
    ], children);
  }

  function getStyleClass() : String {
    return switch style {
      case Default: "";
      case Primary: "btn-primary";
      case Secondary: "btn-secondary";
      case Info: "btn-info";
      case Warning: "btn-warn";
      case Danger: "btn-danger";
      case Success: "btn-success";
    };
  }

  function getSizeClass() : String {
    return switch size {
      case Default: "";
      case Large: "btn-lg";
      case Small: "btn-sm";
    };
  }
}
