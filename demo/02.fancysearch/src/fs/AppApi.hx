package fs;

import thx.load.Loader;

class AppApi {
  var path : String;

  public var state(default, null) : AppState;
  public var onUpdate : Void -> Void;

  public function new(path : String) {
    this.path = path;
    this.onUpdate = function() {};
    this.state = Loading;
  }

  public function load() {
    state = Loading;
    onUpdate();
    Loader.getJson(Loader.normalizePath(path))
      .success(function(data) {
        state = Data(data.vegetable_cooking_times);
      })
      .failure(function(err) {
        state = Error(err.toString());
      })
      .always(onUpdate);
  }
}
