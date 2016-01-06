package doom.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
using haxe.macro.ExprTools;

class AutoComponentBuild {
  public static function build() : Array<Field> {
    /*
    trace('---- getLocalModule() ----');
    var localModule = Context.getLocalModule();
    trace('${localModule}');

    // create new module for State typedef
    // create new module for Api typedef


    trace('---- getLocalClass() ----');
    var localClass = Context.getLocalClass().get();
    trace('${localClass}');
    trace('name: ${localClass.name}');
    trace('superClass: ${localClass.superClass}');
    trace('statics: ${localClass.statics}');
    trace('pos: ${localClass.pos}');
    trace('params: ${localClass.params}');
    trace('pack: ${localClass.pack}');
    trace('overrides: ${localClass.overrides}');
    trace('module: ${localClass.module}');
    trace('meta: ${localClass.meta}');
    trace('kind: ${localClass.kind}');
    trace('isPrivate: ${localClass.isPrivate}');
    trace('isInterface: ${localClass.isInterface}');
    trace('isExtern: ${localClass.isExtern}');
    trace('interfaces: ${localClass.interfaces}');
    trace('init: ${localClass.init}');
    trace('fields: ${localClass.fields}');
    trace('exclude: ${localClass.exclude}');
    trace('doc: ${localClass.doc}');
    trace('constructor: ${localClass.constructor}');

    var classComponentRef = switch Context.getType("doom.Component") {
      case TInst(tRef, _) : tRef;
      case _: Context.error('cannot find doom.Component Type', Context.currentPos());
    };

    localClass.superClass = {
      t: classComponentRef,
      params: []
    };

    trace(localClass);


    var buildFields = Context.getBuildFields();
    for(field in buildFields) {
      //trace(field);
      trace('---- getBuildFields() field ----');
      trace('name: ${field.name}');
      trace('pos: ${field.pos}');
      trace('meta: ${field.meta}');
      trace('doc: ${field.doc}');
      trace('access: ${field.access}');
      trace('kind: ${field.kind}');

      trace('kind info:');
      switch field.kind {
        case FVar(read, write) :
          trace('FVar');
          trace('read: $read');
          trace('write: $write');
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
    }

    return buildFields;
    */
    return Context.getBuildFields();
  }
}
