package svg;

import doom.Svg.*;
import doom.Component;

class SvgApp extends Component<{}, {}> {
  override function render() {
    return SVG([
        "width" => "230",
        "height" => "100"
      ], [
        CIRCLE(["cx" => "50",  "cy" => "50", "r" => "25", "fill" => "mediumorchid"]),
        CIRCLE(["cx" => "125", "cy" => "50", "r" => "25", "fill" => "#ff0099"]),
        CIRCLE(["cx" => "200", "cy" => "50", "r" => "25", "fill" => "crimson"])
      ]);
  }
}
