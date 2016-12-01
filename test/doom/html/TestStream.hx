package doom.html;

import js.Browser.*;
import utest.Assert;
import doom.core.VNode;
import dots.Dom;
import doom.html.Html.*;
import thx.stream.Property;
import thx.stream.Stream;
import haxe.ds.Option;

class TestStream extends Base {
  public function testObserve() {
    var prop: Property<Option<String>> = new Property(None);
    var stream = prop.stream()
                  .map(function(maybe) return switch maybe {
                    case Some(name): div(null, name);
                    case None: div("empty");
                  });
    render.stream(stream, el());
    assertHtml('<div>empty</div>');
    prop.set(Some("value"));
    assertHtml('<div>value</div>');
  }
}
