import Doom.*;
import doom.*;
import js.html.*;
import utest.Assert;
import auto.AutoButton;
import auto.AutoButton.AutoButtonStyle;

class TestAutoComponent {
  public function new() {}

  public function testAutoComponent() {
    //var api : auto.AutoButtonApi = { };

    // normal ctor
    var autoButton1 = new AutoButton({
      voidApi: voidApi,
      voidApiOpt: voidApi,
      elementApi: elementApi,
      elementApiOpt: elementApi,
      eventApi: eventApi,
      eventApiOpt: eventApi,
    }, {
      intValue: 1,
      intValueOpt: 1,
      intValueDef: 1,
      stringValue: "test",
      stringValueOpt: "test",
      stringValueDef: "test",
      enumValue: Secondary,
      enumValueOpt: Secondary,
      enumValueDef: Secondary,
    });

    var autoButton2 = new AutoButton({
      voidApi: voidApi,
      //voidApiOpt: voidApi,
      elementApi: elementApi,
      //elementApiOpt: elementApi,
      eventApi: eventApi,
      //eventApiOpt: eventApi,
    }, {
      intValue: 1,
      //intValueOpt: 1,
      //intValueDef: 1,
      stringValue: "test",
      //stringValueOpt: "test",
      //stringValueDef: "test",
      enumValue: Secondary,
      //enumValueOpt: Secondary,
      //enumValueDef: Secondary,
    });

    // static create ctor
    //var autoButton2 = AutoButton.create(voidApi, elementApi, eventApi, Secondary);

    Assert.pass();
  }

  function voidApi() : Void {
  }

  function elementApi(element : ButtonElement) : Void {
  }

  function eventApi(event : Event) : Void {
  }
}
