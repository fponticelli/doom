package ac;

import Doom.*;
import doom.*;

@:children(none)
class AutoWidget extends AutoComponent {
  @:state
  public var title : String;

  @:state('')
  public var subTitle : String;

  @:state
  public var content : String;

  @:state(opt)
  public var footer : String;

  public override function render() : Node {
    return div([
      "class" => "widget"
    ], [
      hr(),
      h1("Widget"),
      div(["class" => "widget-title"], h2('Title: $title')),
      div(["class" => "widget-title"], h3('Sub-title: $subTitle')),
      div(["class" => "widget-title"], p(content)),
      footer != null ? div(["class" => "widget-title"], p('Footer: footer')) : dummy(),
      hr(),
    ]);
  }
}
