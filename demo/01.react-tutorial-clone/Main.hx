import doom.Component;
import doom.HtmlNode;
import doom.Node.*;
import Markdown.*;
import thx.Nil;
import thx.promise.*;
import thx.load.Loader;

class Main {
  public static function main() {
    var comments = [
      { author : "Pete Hunt", text : "This is one comment" },
      { author : "Jordan Walke", text : "This is *another* comment" }
    ];
    var main = js.Browser.document.getElementById("content");
    var box = new CommentBox();
    box
      .mount(main)
      .update("http://localhost:3000/api/comments");
    //new Counter().mount(main).update(0);
  }
}

class Counter extends Component<Int> {
  override function render(x : Int) {
    thx.Timer.delay(function() update(x + 1), 500);
    return el("div", ["class" => "counter"], 'count $x');
  }
}

class CommentBox extends Component<String> {
  override function render(url)
    return el("div",
      ["class" => "commentBox"],
      [
        el("h1", "comments"),
        new CommentList().view(Load(url)),
        new CommentForm().view(nil)
      ]
    );
}

class CommentList extends Component<HttpLoader<Array<CommentData>>> {
  override function render(data : HttpLoader<Array<CommentData>>) return switch data {
    case Load(url):
      Loader.getJson(url)
        .mapSuccessPromise(function(comments) {
          return Promise.create(function(resolve, _) thx.Timer.delay(function() resolve(comments), 2000));
        })
        .success(function(comments) {
          update(Loaded(comments));
        })
        .failure(function(err) {
          update(Error(err.toString()));
        });
      el("div", ["class" => "loading"], "Loading ...");
    case Error(msg):
      el("div", ["class" => "error"], msg);
    case Loaded(comments):
      el("div",
        ["class" => "commentList"],
        comments.map(function(comment) return new Comment().view(comment))
      );
  }
}

class CommentForm extends Component<Nil> {
  override function render(_)
    return el("div",
      ["class" => "commentForm"],
      "Hello, world! I am a CommentForm."
    );
}

class Comment extends Component<CommentData> {
  override function render(comment : CommentData)
    return el("div",
      ["class" => "comment"],
      [
        el("h2",
          ["class" => "comment"],
          comment.author
        ),
        raw(markdownToHtml(comment.text))
      ]
    );
}

typedef CommentData = {
  author : String,
  text : String
}

enum HttpLoader<T> {
  Load(url : String);
  Error(msg : String);
  Loaded(data : T);
}
