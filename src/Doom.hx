import doom.IComponent;
import js.html.Element;

class Doom {
  public static function mount(component : IComponent, ref : Element) {
    if(null == ref)
      throw 'reference element is set to null';
    ref.innerHTML = "";
    component.init();
    ref.appendChild(component.element);
  }
}
