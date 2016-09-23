package doom.html;

import js.html.Element;
import js.html.Node;
using thx.Strings;

@:autoBuild(doom.html.macro.Styles.buildNamespace())
class Component<Props> extends doom.core.Component<Props, Node> {
  public var element(get, never): Null<Element>;

  public function classes(): String
    return "";

  public function selector(): String {
    var parts = classes().trim().split(" ").filter(function(cls) return cls != "");
    if(parts.length == 0) return "";
    return parts.map(function(part) return '.$part').join("");
  }

  inline function get_element(): Null<Element>
    return cast node;
}
