package doom;

import haxe.CallStack;
import haxe.PosInfos;
using thx.Strings;

class ComponentError extends thx.Error {
  var component : Component<Dynamic>;
  public function new(message, component : Component<Dynamic>, ?stack:Array<StackItem>, ?pos:PosInfos) {
    super(message, stack, pos);
    this.component = component;
  }

  override public function toString() {
    return component.toString().ellipsisMiddle(80) + ": " + super.toString();
  }
}
