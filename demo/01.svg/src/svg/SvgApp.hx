package svg;

import Doom.*;
import doom.StatelessComponent;

class SvgApp extends StatelessComponent {
  override function render() {
    return el("svg:svg", [
        "width" => "230",
        "height" => "100"
      ], [
        el("svg:circle", [
          "cx" => "50", "cy" => "50", "r" => "25", "fill" => "mediumorchid"
        ]),
        el("svg:circle", [
          "cx" => "125", "cy" => "50", "r" => "25", "fill" => "#ff0099"
        ]),
        el("svg:circle", [
          "cx" => "200", "cy" => "50", "r" => "25", "fill" => "crimson"
        ])
      ]);
  }
}
