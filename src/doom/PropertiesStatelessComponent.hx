package doom;

import js.html.Element;
using doom.Patch;

class PropertiesStatelessComponent<Properties> extends StatelessComponent {
  public var prop : Properties;
  public function new(prop : Properties) {
    this.prop = prop;
    super();
  }
}
