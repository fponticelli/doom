import thx.Nil;
import thx.Timer;
import doom.View;
import js.Browser.*;
using doom.Node;
import doom.Node.*;

class Main {
  public static function main() {
    new Like(document.getElementById("content"), { liked : false });
  }
}

class Like extends View<LikeModel> {
  override function render() {
    var text = state.liked ? 'like' : "haven't liked";
    return el("p",
      ["click" => handleClick.bind(_, state.liked)],
      'You $text this. Click to toggle.'
    );
  }

  function handleClick(_, liked)
    update({ liked : !liked});
}

typedef LikeModel = {
  liked : Bool
}
