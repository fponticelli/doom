#if (js && html)
package doom;

import js.html.*;
import js.Browser.*;
import doom.Node;

class HtmlNode {
  public static function toHtml(node : Node) : js.html.Node return switch (node : NodeImpl) {
    case Element(name, attributes, events, children):
      var el = document.createElement(name);
      for(key in attributes.keys())
        el.setAttribute(key, attributes.get(key));
      for(child in children) {
        var n = toHtml(child);
        if(null != n)
          el.appendChild(n);
      }
      el;
    case Text(text): document.createTextNode(text);
    case Comment(text): document.createComment(text);
    case Empty: null;
  }
}
#end
