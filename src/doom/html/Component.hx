package doom.html;

import js.html.Element;
import js.html.Node;

@:autoBuild(doom.html.macro.Styles.buildNamespace())
class Component<Props> extends doom.core.Component<Props, Node> {
  public var element(get, never) : Null<Element>;

  public function classes() : String
    return "";

  inline function get_element() : Null<Element>
    return cast node;
}
