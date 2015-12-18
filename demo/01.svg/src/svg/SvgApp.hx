package svg;

import doom.Svg.*;
import doom.Component;

class SvgApp extends Component<{}, {}> {
  override function render() {
    return svg([
        "width" => "230",
        "height" => "100"
      ], [
        circle(["cx" => "50",  "cy" => "50", "r" => "25", "fill" => "mediumorchid"]),
        circle(["cx" => "125", "cy" => "50", "r" => "25", "fill" => "#ff0099"]),
        circle(["cx" => "200", "cy" => "50", "r" => "25", "fill" => "crimson"])
      ]);
  }
}
