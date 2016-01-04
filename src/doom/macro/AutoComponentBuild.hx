package doom.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
using haxe.macro.ExprTools;

class AutoComponentBuild {
  public static function build() : Array<Field> {
    var buildFields = Context.getBuildFields();
    var localClass = Context.getLocalClass();
    for(field in buildFields) {
      //trace(field);
      trace('name: ${field.name}');
      trace('pos: ${field.pos}');
      trace('meta:');
      for (meta in field.meta) {
        trace('  ${field.meta}');
      }
      trace('kind: ${field.kind}');
      trace('doc: ${field.doc}');
      trace('access: ${field.access}');

      switch field.kind {
        case FVar(read, write) :
          trace('FVar');
          trace(read);
          trace(write);
        case FFun(f) :
          trace('FFun');
          trace(f);
        case FProp(g, s, t, e) :
          trace('FProp');
          trace(g);
          trace(s);
          trace(t);
          trace(ExprTools.toString(e));
      };
      trace('----');
    }
    trace('${localClass}');
    trace('----');
    return buildFields;
  }
}
