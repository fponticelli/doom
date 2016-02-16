import doom.core.VNode;
import js.html.Element;

@:autoBuild(doom.macro.AutoComponentBuild.build())
class Doom extends doom.ComponentBase {
  public static function mount(node : VNode, ref : Element) {
    // if(null == ref)
    //   throw 'reference element is set to null';
    // switch node {
    //   case ComponentNode(comp):
    //     ref.innerHTML = "";
    //     var post = [];
    //     comp.node = comp.render();
    //     comp.init(post);
    //     ref.appendChild(comp.element);
    //     for(f in post) f();
    //   case other:
    //     var post = [];
    //     var dom = doom.HtmlNode.toHtml(other, post);
    //     ref.innerHTML = "";
    //     ref.appendChild(dom);
    //     for(f in post) f();
    // }
  }
}
