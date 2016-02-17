package doom.html;

import js.Browser.*;
import doom.core.VNode;
import utest.Assert;

class Base {
  public function new() {}

  var render : Render;
  public function setup() {
    document.body.innerHTML = "";
    render = new Render();
  }
  public function teardown() {
    document.body.innerHTML = "";
  }

  public function asText() {
    return document.body.innerHTML;
  }

  public function first() : js.html.Node {
    return document.body.firstChild;
  }

  public function body() {
    return document.body;
  }

  public function mount(node : VNode) {
    render.mount(node, body());
  }

  public function apply(node : VNode) {
    render.apply(node, first());
  }

  public function select(selector : String) {
    return body().querySelector(selector);
  }

  public function assertHtml(expectHtml : String, ?pos : haxe.PosInfos) {
    Assert.equals(expectHtml, asText(), pos);
  }
}
