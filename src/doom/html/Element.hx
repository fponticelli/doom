package doom.html;

import doom.core.VNode;
import doom.core.VNodes;

class Element<ElementType: Element<ElementType>> extends BaseElement<ElementType> {
  var children: VNodes;

  public function new(tag: String, ?children: VNodes) {
    super(tag);
    this.children = null == children ? [] : children;
  }

  override function render(): VNode
    return Html.el(tag, attributes, children);

  public function prepend(children: VNodes)
    return setChildren(children.concat(this.children));

  public function append(children: VNodes)
    return setChildren(this.children.concat(children));

  public function setChildren(children: VNodes) {
    this.children = children;
    return self();
  }
}
