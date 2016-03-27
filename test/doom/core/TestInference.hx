package doom.core;

import utest.Assert;
import doom.core.VNode;

class TestInference {
  public function new() {}

  public function testVNode() {
    var child : VNode = new Sample({});
    switch child {
      case Comp(c) if(Std.is(c, Sample)): Assert.pass();
      case _: Assert.fail();
    }

    child = VNode.text("hi");
    switch child {
      case Text("hi"): Assert.pass();
      case _: Assert.fail();
    }

    child = "hi again";
    switch child {
      case Text("hi again"): Assert.pass();
      case _: Assert.fail();
    }
  }

  public function testArgumentInference() {
    var s = new Sample({}, "child");
    s = new Sample({}, ["child"]);
    s = new Sample({}, new Sample({}));
    s = new Sample({}, ["child", new Sample({})]);
    s = new Sample({}, [new Sample({}), "child"]);
    s = new Sample({}, ["a", "child"]);

    Assert.pass();
  }

  public function testVNodesFields() {
    var children : VNodes = [];
    Assert.isNull(children[0]);
  }

  public function testVNodes() {
    var children : VNodes = new Sample({});
    switch (children : Array<VNodeImpl>) {
      case [Comp(c)] if(Std.is(c, Sample)): Assert.pass();
      case _: Assert.fail();
    }

    children = VNode.text("hi");
    switch (children : Array<VNodeImpl>) {
      case [Text("hi")]: Assert.pass();
      case _: Assert.fail();
    }

    children = "hi again";
    switch (children : Array<VNode>) {
      case [Text("hi again")]: Assert.pass();
      case _: Assert.fail();
    }

    children = ["hi"];
    switch (children : Array<VNode>) {
      case [Text("hi")]: Assert.pass();
      case _: Assert.fail();
    }

    // var a : Values = ["1", 2, new Map()];
    // trace(a);
    //
    // function f(a : Values) {trace(a);}
    // f(["1", 2, new Map()]);
  }
}


private class Sample extends doom.core.Component<{}, {}> {

}

//
// abstract Value(ValueImpl) from ValueImpl to ValueImpl {
//   @:from public static function fromString(s:String):Value return VString(s);
//   @:from public static function fromInt(i:Int):Value return VInt(i);
//   @:from public static function fromMap(m:Map<String, String>):Value return VMap(m);
// }
//
// enum ValueImpl {
//   VInt(v : Int);
//   VString(s : String);
//   VMap(m : Map<String, String>);
// }
//
// abstract Values(Array<Value>) from Array<Value> to Array<Value> {}
