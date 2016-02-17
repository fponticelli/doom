package doom.html;

import doom.html.Html.*;
import dots.Html.parseElement;
import utest.Assert;

class TestAttributes extends Base {
  public function testBooleanAttribute() {
    var el = parseElement('<input type="checkbox">');

    render.applyNodeAttributes(["type" => "checkbox", "checked" => true], el);
    assertSameHtml('<input type="checkbox" checked="checked">', el);
    render.applyNodeAttributes(["type" => "checkbox", "checked" => false], el);
    assertSameHtml('<input type="checkbox">', el);
  }

  public function testSettingAttributes() {
    var div = parseElement('<div id="main"></div>');
    render.applyNodeAttributes(["class" => "container"], div);
    Assert.equals("container", div.getAttribute("class"));
    Assert.isFalse(div.hasAttribute("id"));
  }
}
