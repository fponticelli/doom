package doom.html;

import js.Browser.*;
import doom.core.VChild;
import doom.core.VNode;
import utest.Assert;

class Base {
  public function new() {}

  var render : Render;
  public function setup() {
    document.body.innerHTML = "";
    // phases = [];
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

  public function mount(node : VChild) {
    render.mount(node, body());
  }

  public function apply(node : VNode) {
    render.apply(node, first());
  }

  public function select(selector : String) {
    return body().querySelector(selector);
  }

  public function assertHtml(expectedHtml : String, ?pos : haxe.PosInfos) {
    Assert.equals(expectedHtml, asText(), pos);
  }

  public function assertSameHtml(expectedHtml : String, el : js.html.Element, ?pos : haxe.PosInfos) {
    Assert.equals(expectedHtml, el.outerHTML, pos);
  }

  // var phases : Array<PhaseInfo>;
  // public function addPhase(phase : Phase, comp : doom.core.Component<Dynamic, Dynamic>) {
  //
  // }
  //
  // public function resetPhases() {
  //
  // }
  //
  // public function assertPhases(expected : Array<PhaseInfo>, ?pos : haxe.PosInfos) {
  //   Assert.same(expected, phases, pos);
  // }
}
