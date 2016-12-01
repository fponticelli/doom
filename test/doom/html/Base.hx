package doom.html;

import js.Browser.*;
import doom.core.VNode;
import utest.Assert;

class Base {
  public function new() {}

  var render : Render;
  public function setup() {
    el().innerHTML = "";
    render = new Render();
  }
  public function teardown() {
    el().innerHTML = "";
  }

  public function asText() {
    return el().innerHTML;
  }

  public function first() : js.html.Node {
    return el().firstChild;
  }

  public function el() {
    return document.getElementById("ref");
  }

  public function mount(node : VNode) {
    render.mount(node, el());
  }

  public function apply(node : VNode) {
    render.apply(node, first());
  }

  public function select(selector : String) {
    return el().querySelector(selector);
  }

  public function assertHtml(expectedHtml : String, ?pos : haxe.PosInfos) {
    Assert.equals(expectedHtml, asText(), pos);
  }

  public function assertSameHtml(expectedHtml : String, el : js.html.Element, ?pos : haxe.PosInfos) {
    Assert.equals(expectedHtml, el.outerHTML, pos);
  }
}
