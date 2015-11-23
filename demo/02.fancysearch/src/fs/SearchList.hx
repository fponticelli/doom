package fs;

import Doom.*;
import doom.Component;
import doom.Node;
using thx.Functions;

class SearchList extends Component<AppState> {
  override function render() {
    var prop = {
      listener : function(s : String) {}
    }
    return switch state {
      case Loading:
        DIV("Loading ...");
      case Data(data):
        DIV([
          HEADER(new FancySearchComponent({
            //"classes" : ["fancify"],
            suggestionOptions : {
              suggestions : data.map(function(v) return v.vegetable),
              onChooseSelection : function(_, s) prop.listener(s)
            }
          }, {})),
          comp(new List(prop, data))
        ]);
      case Error(msg):
        DIV(["class" => "error"], msg);
    };
  }

  function handleSelectionChange(_, s : String) {
    trace(s);
  }
}
