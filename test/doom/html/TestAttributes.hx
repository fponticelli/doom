package doom.html;

import doom.html.Html.*;
import dots.Html.parseElement;
import utest.Assert;

class TestAttributes extends Base {
  public function testBooleanAttribute() {
    var el : js.html.InputElement = cast parseElement('<input type="checkbox">');
    Assert.isFalse(el.checked);
    render.applyNodeAttributes(["type" => "checkbox", "checked" => true], el);
    assertSameHtml('<input type="checkbox">', el);
    Assert.isTrue(el.checked);
    render.applyNodeAttributes(["type" => "checkbox", "checked" => false], el);
    assertSameHtml('<input type="checkbox">', el);
    Assert.isFalse(el.checked);
  }

  public function testBooleanAttributeChecked() {
    var el : js.html.InputElement = cast parseElement('<input type="checkbox" checked>');
    Assert.isTrue(el.checked);
    render.applyNodeAttributes(["type" => "checkbox", "checked" => false], el);
    assertSameHtml('<input type="checkbox" checked="">', el);
    Assert.isFalse(el.checked);
    render.applyNodeAttributes(["type" => "checkbox", "checked" => true], el);
    assertSameHtml('<input type="checkbox" checked="">', el);
    Assert.isTrue(el.checked);
  }

  public function testSettingAttributes() {
    var div = parseElement('<div id="main"></div>');
    render.applyNodeAttributes(["class" => "container"], div);
    Assert.equals("container", div.getAttribute("class"));
    Assert.isFalse(div.hasAttribute("id"));
  }
}
