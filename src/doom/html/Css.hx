package doom.html;

class Css {
  macro public static function save(path : String) {
    doom.html.macro.Styles.saveCss(path);
    return macro null;
  }
}
