package fs;

import Doom.*;
import doom.Component;
import fancy.Search;
import fancy.search.util.Types;

class FancySearchComponent extends Component<FancySearchOptions, {}> {
  override function render() {
    return INPUT([
      "class" => "fancy-search-component fancify",
      "placeholder" => "type to search",
      "type"  => "text",
      "mount" => handleMount
    ]);
  }

  function handleMount(el : js.html.InputElement) {
    var fancy = new Search(cast el, api);
  }
}
