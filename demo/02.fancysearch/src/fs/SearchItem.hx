package fs;

import Doom.*;
import doom.Component;
import doom.Node;
import haxe.ds.Option;
using thx.Functions;
using thx.Arrays;
import thx.Options;
import thx.ReadonlyArray;

class SearchItem extends Component<{}, AppState> {
  override function render() {
    var api = {
            listener : function(s : String) {}
          },
        veggieComp = new VeggieComponent({}, None);

    return switch state {
      case Loading:
        section(["class" => "container"], "Loading ...");
      case Data(data):
        section(["class" => "container"], [
          header(div(["class" => "fancy"],
            new FancySearchComponent(
              {}, {
              suggestionOptions : {
                suggestions : data.map(function(v) return v.vegetable),
                onChooseSelection : function(_, s) updateVeggie(veggieComp, s, data)
              }
            }))),
          comp(veggieComp)
        ]);
      case Error(msg):
        section(["class" => "container error"], msg);
    };
  }

  function updateVeggie(comp : VeggieComponent, veggie : String, data : ReadonlyArray<Veggie>) {
    veggie = veggie.toLowerCase();
    var item = data.find.fn(_.vegetable.toLowerCase() == veggie);
    comp.update(Options.ofValue(item));
  }
}
