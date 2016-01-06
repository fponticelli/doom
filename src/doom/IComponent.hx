package doom;

import doom.Node.Nodes;
import js.html.Element;

interface IComponent {
  public var element : Element;
  public var node : Node;
  public var children : Nodes;
  public function init() : Void;
  public function render() : Node;
  public function mount() : Void;
  public function refresh() : Void;
  public function destroy() : Void;
  public function toString() : String;
}
