package doom;

import js.html.Element;
using doom.Patch;

class ApiStatelessComponent<Api> extends StatelessComponent {
  public var api : Api;
  public function new(api : Api) {
    this.api = api;
    super();
  }
}
