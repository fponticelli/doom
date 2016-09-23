package doom.html;

using thx.Strings;
import doom.core.VNode;

@:autoBuild(doom.html.macro.Styles.buildNamespace())
class Renderable implements doom.core.Renderable {
  public function classes(): String
    return "";

  public function selector(): String {
    var parts = classes().trim().split(" ").filter(function(cls) return cls != "");
    if(parts.length == 0) return "";
    return parts.map(function(part) return '.$part').join("");
  }

  public function render(): VNode
    return throw new thx.error.AbstractMethod();
}
