package doom.html.macro;

import sys.FileSystem;
import sys.io.File;
import haxe.macro.Context;
import haxe.macro.Type;
import thx.macro.MacroClassTypes;
import thx.macro.Macros;
import thx.OrderedMap;
using thx.Arrays;
using thx.Strings;

class Styles {
  public static function buildNamespace() {
    var fields = Context.getBuildFields(),
        cls = Context.getLocalClass(),
        types = MacroClassTypes.inheritanceAsStrings(cls.get()).slice(0, -2),
        normalizedNames = types.map(normalizeName),
        normalizedName = normalizedNames[0],
        classes = normalizedNames.join(" ");

    fields.push({
      name : 'classes',
      pos : Context.currentPos(),
      kind : FFun({
        ret : macro : String,
        args : [],
        expr : macro return $v{classes},
      }),
      access : [AOverride]
    });

    var css = loadCssForComponent(cls.get());
    if(null != css) {
      css = transformCss(css, '#ns', normalizedName).trim();
      var name = MacroClassTypes.toString(cls.get());
      cssMap.set(name, css);
    }

    return fields;
  }

  public static function normalizeName(typeName : String) {
    var parts = typeName.split('.')
                  .map(Strings.underscore)
                  .map(Strings.dasherize)
                  .map(function(v : String) return v.startsWith("-") ? ("_" + v.substring(1)) : v);
    return parts.join("_");
  }

  public static function loadCssForComponent(cls : ClassType) {
    var parts = cls.pack.copy(),
        priv = null;
    if(parts.last().startsWith("_")) { // private class
      priv = parts.pop().substring(1);
    }
    var pack = parts.join(".");
    for(dir in Macros.getPackageDirectories(pack)) {
      var file = (null != priv ? priv + "_" : "") + cls.name;
      var path = '$dir/$file.css';
      if(!FileSystem.exists(path))
        continue;
      Context.registerModuleDependency(cls.module, path);
      return File.getContent(path);
    }
    return null;
  }

  public static function transformCss(css : String, placeholder : String, compName : String)
    return css.replace(placeholder, '.$compName');

  public static function saveCss(path : String) {
    var css = [];
    for(value in cssMap) {
      css.push(value);
    }
    File.saveContent(path, css.join("\n") + "\n");
  }

  static var cssMap : OrderedMap<String, String> = OrderedMap.createString();
}
