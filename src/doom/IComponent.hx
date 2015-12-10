package doom;

import js.html.Element;

interface IComponent {
  public var element : Element;
  public var node : Node;

  public function init() : Void;
  public function toString() : String;

  public function mount() : Void;
}
