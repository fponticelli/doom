import doom.html.Component;
import doom.html.Html.*;
using thx.Objects;
import thx.Timer;


// The data model of our app: not so complex
typedef ClickModel = {
  clicks : Int,
}

// Entry point for the JS application
class CounterExample {
  static function main() {
    // mounting our handmade element (ClickCounter) directly on the body tag:
    Doom.browser.mount(new ClickCounter({
      clicks: 0
    }), js.Browser.document.querySelector("body"));
  }
}

class ClickCounter extends Component<ClickModel> {
  override function render() {
      var components:doom.core.VNodes = if (props.clicks == 0 )
                                    /** Before the user makes any click we show the instructions **/
                                        [ p("Please click somewhere in this page") ]
                                    else
                                    /** Then the "application" with a fancy reset button **/
                                        [ 
                                            h1("Clicks " + Std.string(props.clicks)),
                                            div(["style" => "height: 30px"], ""),
                                            button(["type" => "button", "click" => reset], "reset counter")
                                        ];
                                     
      var mainNode = div( // Once upon a time was a web page covered by a single div layer:
                      ["style" => "position:fixed; top:0px; left:0px; width:100%; height:100%;", 
                      // which contained a click event
                      "click" => onClick], 
                      // with some children elements
                      components);
      return mainNode;
  }


  private function onClick(e:Dynamic) {
      // Understand that the value of the props is updated ONLY at the to use the update.
      //  if for some reason is not clear, incomment the next traces:
      // trace("We start with " + props.clicks + " clicks...");    
      update(props.shallowMerge({
        clicks: props.clicks + 1
      }));
      // trace("   ...but now we got " + props.clicks + " clicks!\n\n\n\n");
  }


  private function reset(e:Dynamic) {
      trace("Setting counter back to 0!");
      update(props.shallowMerge({
        clicks: 0
      }));
        /** Some JS stuff:
            we need to prevent that the event continues propagating
            after click the rest, otherwise our counter will immediately
            count the click and we will get back on 1
            P.S. only modern browsers
       **/
    var event:Dynamic = untyped js.Browser.window.event; // we need to capture back the event variable
    //IE9 & Other Browsers
    if (event.stopPropagation) event.stopPropagation()
    // IE8 and Lower
    else event.cancelBubble = true;
  }
}