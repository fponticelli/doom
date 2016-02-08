package doom;

import doom.Node.Nodes;
import js.html.Element;

interface IComponent {
  public var element : Element;
  public var node : Node;
  public var isUnmounted : Bool;
  public function init(post : Array<Void -> Void>) : Void;
  public function render() : Node;

  public function didMount() : Void;
  public function didRefresh() : Void;
  public function didUnmount() : Void;

  public function toString() : String;
}
