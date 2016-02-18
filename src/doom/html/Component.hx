package doom.html;

import js.html.Element;
import js.html.Node;

class Component<Props> extends doom.core.Component<Props, Node> {
  public var element(get, never) : Null<Element>;

  inline function get_element() : Null<Element>
    return cast node;
}
