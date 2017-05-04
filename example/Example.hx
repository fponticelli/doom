import doom.html.Component;
import doom.html.Html.*;
using thx.Objects;
import thx.Timer;

class Example {
  static function main() {
    var div = js.Browser.document.querySelector("body"); // mounting directly on the body
    Doom.browser.mount(new BannerComponent({
      messages : [ "Doom", "is", "Magic", "(but the good kind)" ],
      delay : 500,
      toDisplay : 0
    }), div);
  }
}

class BannerComponent extends Component<BannerProps> {
  override function render() {
    Timer.delay(function() {
      update(props.shallowMerge({
        toDisplay : (props.toDisplay + 1) % props.messages.length
      }));
    }, props.delay);
    return h1(props.messages[props.toDisplay]);
  }
}

typedef BannerProps = {
  messages : Array<String>,
  delay : Int,
  toDisplay : Int
}