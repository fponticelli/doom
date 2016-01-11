package doom.macro;

import haxe.macro.ComplexTypeTools;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;
using haxe.macro.ExprTools;
import thx.macro.MacroFields;
import thx.macro.MacroClassTypes;
using thx.Arrays;
using thx.Strings;

class AutoComponentBuild {
  // field names
  static inline var CHILDREN_IDENT = 'children';
  static inline var STATE_IDENT = 'state';
  static inline var API_IDENT = 'api';
  static inline var NEW_IDENT = 'new';
  static inline var WITH_IDENT = 'with';
  static inline var UPDATE_IDENT = "update";
  static inline var SHOULD_RENDER_IDENT = "shouldRender";
  static inline var NEW_STATE_IDENT = "newState";
  static inline var OLD_STATE_IDENT = "newState";

  // metadata names
  static inline var CHILDREN_META = ':$CHILDREN_IDENT';
  static inline var STATE_META = ':$STATE_IDENT';
  static inline var API_META = ':$API_IDENT';

  // metadata param identifiers
  static inline var OPT_IDENT = 'opt';
  static inline var REQ_IDENT = 'req';
  static inline var NONE_IDENT = 'none';

  // Api/State type suffixes
  static inline var STATE_SUFFIX = 'State';
  static inline var API_SUFFIX = 'Api';

  public static function build() : Array<Field> {
    var localClass : ClassType = Context.getLocalClass().get();
    var fields : Array<Field> = Context.getBuildFields();

    // Read the metadata from the class and fields
    var childrenMeta = getChildrenMeta(localClass);
    var apiMeta = getFieldsMeta(fields, API_META);
    var stateMeta = getFieldsMeta(fields, STATE_META);

    // Generate the State and Api modules/types from the state/api metadata
    //trace('generateApiModule');
    var apiComplexType = generateModule({ localClass: localClass, meta: apiMeta }, API_IDENT);
    generateOptionsModule({ localClass: localClass, meta: apiMeta }, API_IDENT);

    //trace('generateStateModule');
    var stateComplexType = generateModule({ localClass: localClass, meta: stateMeta }, STATE_IDENT);
    generateOptionsModule({ localClass: localClass, meta: stateMeta }, STATE_IDENT);

    // Add "api" field to class
    //trace('generateApiField');
    fields.push(generateField({
      complexType: apiComplexType
    }, API_IDENT));

    // Add "state" field to class
    //trace('generateStateField');
    fields.push(generateField({
      complexType: stateComplexType
    }, STATE_IDENT));

    // Add "new" (constructor) function to class
    //trace('generateConstructor');
    fields.push(generateConstructor({
      childrenMeta: childrenMeta,
      apiMeta: apiMeta,
      apiComplexType: apiComplexType,
      stateMeta: stateMeta,
      stateComplexType: stateComplexType,
    }));

    if(!thx.Arrays.any(fields, function(field) {
      return field.name == WITH_IDENT;
    })) {
      fields.push(generateWith({
        childrenMeta : childrenMeta,
        apiMeta: apiMeta,
        stateMeta: stateMeta,
      }));
    }

    // Change "@:api" vars to getter properties for api object
    changeFieldsToProperties(fields, apiMeta, API_IDENT);

    // Change "@:state" vars to getter properties for state object
    changeFieldsToProperties(fields, stateMeta, STATE_IDENT);

    // Add "update" function to class
    fields.push(generateUpdateFunction({ stateComplexType: stateComplexType }));

    // Add "shouldRender" function to class
    if (!hasFieldByName(fields, SHOULD_RENDER_IDENT)) {
      fields.push(generateShouldRenderFunction({ stateComplexType: stateComplexType }));
    }

    return fields;
  }

  static function getChildrenMeta(classType : ClassType) : ChildrenMeta {
    if (!classType.meta.has(CHILDREN_META)) return Optional;
    var metadataEntries = classType.meta.extract(CHILDREN_META);
    for (metadataEntry in metadataEntries) {
      if (metadataEntry.params == null) return Optional;
      for (param in metadataEntry.params) {
        switch param.expr {
          case EConst(CIdent(OPT_IDENT)) : return Optional;
          case EConst(CIdent(REQ_IDENT)) : return Required;
          case EConst(CIdent(NONE_IDENT)) : return None;
          case _ : // no-op
        };
      }
    }
    return Optional;
  }

  static function getFieldsMeta(fields : Array<Field>, name : String) : FieldsMeta {
    if (fields == null || fields.length == 0) return None;
    var stateFields = fields.filter(function(field) {
      return hasMeta(field, name);
    });
    if (stateFields == null || stateFields.length == 0) return None;
    return Many(fieldsToFieldMetas(stateFields, name));
  }

  static function fieldsToFieldMetas(fields : Array<Field>, metaName : String) : Array<FieldMeta> {
    return fields.map(fieldToFieldMeta.bind(_, metaName));
  }

  static function fieldToFieldMeta(field : Field, metaName : String) : FieldMeta {
    // Field is required if it has no meta params, or it has no "opt" param and no default value param
    var isRequired = !hasMetaParams(field, metaName) ||
      (!hasMetaIdentParam(field, metaName, OPT_IDENT) && !hasMetaDefaultValue(field, metaName));
    //trace('${field.name} is required ${isRequired} -- ${hasMetaParams(field, metaName)} ${hasMetaIdentParam(field, metaName, OPT_IDENT)} ${hasMetaDefaultValue(field, metaName)}');
    var defaultValue = getMetaDefaultValue(field, metaName);
    var hasDefaultValue = defaultValue != null;
    return {
      field: field,
      // field is required if it has no meta params, or does not have the opt param
      isRequired: isRequired,
      hasDefaultValue: hasDefaultValue,
      defaultValue: defaultValue,
    };
  }

  static function fieldMetasToFields(fieldMetas : Array<FieldMeta>) : Array<Field> {
    return fieldMetas.map(fieldMetaToField);
  }

  static function fieldMetaToField(fieldMeta : FieldMeta) : Field {
    var field = fieldMeta.field;
    if (!fieldMeta.isRequired) {
      field = makeFieldTypeOptional(field);
    }
    //if (fieldMeta.hasDefaultValue) {
      //field = addFieldDefaultValue(field, fieldMeta.defaultValue);
    //}
    return field;
  }

  static function getMeta(field : Field, metaName : String) : Null<MetadataEntry> {
    if (field.meta == null) return null;
    for (meta in field.meta) {
      if (meta.name == metaName) return meta;
    }
    return null;
  }

  static function hasMeta(field : Field, metaName : String) : Bool {
    return getMeta(field, metaName) != null;
  }

  static function hasMetaParams(field : Field, metaName : String) : Bool {
    if (!hasMeta(field, metaName)) return false;
    var meta = getMeta(field, metaName);
    return meta.params != null && meta.params.length > 0;
  }

  static function getMetaParams(field : Field, metaName : String) : Array<Expr> {
    if (!hasMetaParams(field, metaName)) return [];
    var meta = getMeta(field, metaName);
    return meta.params;
  }

  static function hasMetaIdentParam(field : Field, metaName : String, identifier : String) : Bool {
    if (!hasMetaParams(field, metaName)) return false;
    var params = getMetaParams(field, metaName);
    for (param in params) {
      switch param.expr {
        case EConst(CIdent(identifier)) : return true;
        case _ : // no-op
      };
    }
    return false;
  }

  static function hasMetaDefaultValue(field : Field, metaName : String) : Bool {
    return getMetaDefaultValue(field, metaName) != null;
  }

  static function getMetaDefaultValue(field : Field, metaName : String) : Null<Expr> {
    if (!hasMeta(field, metaName)) return null;
    if (!hasMetaParams(field, metaName)) return null;
    var params = getMetaParams(field, metaName).filter(function(expr) {
      return switch expr.expr {
        case EConst(CIdent(OPT_IDENT)) : false;
        case EConst(CIdent(REQ_IDENT)) : false;
        case _ : true;
      };
    });
    if (params.length == 0) return null;
    if (params.length != 1) Context.error('Field ${field.name} has more than one default value meta param', field.pos);
    //trace('${field.name} default ${params[0]}');
    return params[0];
  }

  static function generateModule(options: { localClass : ClassType, meta : FieldsMeta }, name : String) : ComplexType {
    var classPackages = options.localClass.pack;
    var className = options.localClass.name;
    var apiTypeName = '${className}${name.upperCaseFirst()}';
    var modulePath : String = '${classPackages.join(".")}.${apiTypeName}';
    var apiTypeDefinition = {
      pos: Context.currentPos(),
      params: null,
      pack: [],
      name: apiTypeName,
      meta: null,
      kind: TDStructure, // TypeDefKind
      isExtern: false,
      fields: fullyQualifyFieldTypes(switch options.meta {
        case None: [];
        case Only(fieldMeta): [fieldMetaToField(fieldMeta)];
        case Many(fieldMetas) : fieldMetasToFields(fieldMetas);
      })
    };
    var types: Array<TypeDefinition> = [apiTypeDefinition];
    var imports : Array<ImportExpr> = [];
    var usings : Array<TypePath> = [];
    Context.defineModule(modulePath, types, imports, usings);
    return TypeTools.toComplexType(Context.getType(modulePath));
  }

  static function generateOptionsModule(options: { localClass : ClassType, meta : FieldsMeta }, name : String) : ComplexType {
    var classPackages = options.localClass.pack;
    var className = options.localClass.name;
    var apiTypeName = '${className}${name.upperCaseFirst()}Options';
    var modulePath : String = '${classPackages.join(".")}.${apiTypeName}';
    var apiTypeDefinition = {
      pos: Context.currentPos(),
      params: null,
      pack: [],
      name: apiTypeName,
      meta: null,
      kind: TDStructure, // TypeDefKind
      isExtern: false,
      fields: fullyQualifyFieldTypes((switch options.meta {
                case None: [];
                case Only(fieldMeta): [fieldMeta];
                case Many(fieldMetas) : fieldMetas;
              })
              .filter(function(item) { return !item.isRequired;})
              .map(fieldMetaToField))
    };
    var types: Array<TypeDefinition> = [apiTypeDefinition];
    var imports : Array<ImportExpr> = [];
    var usings : Array<TypePath> = [];
    Context.defineModule(modulePath, types, imports, usings);
    return TypeTools.toComplexType(Context.getType(modulePath));
  }

  static function generateField(options: { complexType : ComplexType }, name : String) : Field {
    return {
      pos: Context.currentPos(),
      name: name,
      meta: null,
      kind: FVar(options.complexType, null),
      access: [APublic],
    };
  }

  static function generateWithPartsFromMeta(meta : FieldsMeta, name : String) : { args : Array<FunctionArg>, exprs : Array<Expr> } {
    var args = [],
        exprs = [],
        genName = '${name}Var';
    switch meta {
      case None:
        exprs.push(macro var $genName = {});
      case Only(fieldMeta):
        args.push({
          name: fieldMeta.field.name,
          type: MacroFields.getType(fieldMeta.field),
          opt: !fieldMeta.isRequired
        });
        var field = fieldMeta.field.name;
        exprs.push(macro var $genName = { $field : $i{field} });
      case Many(fieldMetas):
        var fieldExprs = [];
        fieldMetas.filter(function(fieldMeta) {
          return fieldMeta.isRequired;
        }).map(function(fieldMeta) {
          args.push({
            name: fieldMeta.field.name,
            type: MacroFields.getType(fieldMeta.field),
            opt: false
          });
        });

        fieldMetas.map(function(fieldMeta) {
          var field = fieldMeta.field.name,
              fieldPath = [name, field];
          // EObjectDecl(fields:Array<{field:String, expr:Expr}>)
          // exprs.push(EObjectDecl());
          // exprs.push(macro $p{fieldPath} = $i{field});
          fieldExprs.push({
            field : field,
            expr : fieldMeta.isRequired ?
              macro $i{field} :
              macro $p{fieldPath}
          });
        });

        var optionalFields = fieldMetas.filter(function(fieldMeta) return !fieldMeta.isRequired);
        if(optionalFields.length > 0) {
          exprs.push(macro if($i{name} == null) $i{name} = {});
          args.push({
            name: name,
            type: TAnonymous(optionalFields.map(function(field) return {
              pos: field.field.pos,
              name: field.field.name,
              meta: [{
                name: ":optional",
                pos: field.field.pos,
                params: null
              }],
              kind: FieldType.FVar(MacroFields.getType(field.field), null),
              doc: null,
              access: [APublic]
            })),
            opt: true
          });
        }
        var e = { expr : EObjectDecl(fieldExprs), pos : Context.currentPos() };
        exprs.push(macro var $genName = $e{e});
    }
    return {
      args : args,
      exprs : exprs
    };
  }

  static function generateWith(options: {
    childrenMeta : ChildrenMeta,
    apiMeta: FieldsMeta,
    stateMeta: FieldsMeta,
  }) : Field {
    var genApi = generateWithPartsFromMeta(options.apiMeta, API_IDENT),
        genState = generateWithPartsFromMeta(options.stateMeta, STATE_IDENT),
        withArgs = genApi.args.concat(genState.args),
        withExprs = genApi.exprs.concat(genState.exprs),
        apiName = '${API_IDENT}Var',
        stateName = '${STATE_IDENT}Var';

    var constructorArgs = [macro $i{apiName}, macro $i{stateName}];
    switch options.childrenMeta {
      case None:
      case Required:
        withArgs.push({
          name: CHILDREN_IDENT,
          type: TypeTools.toComplexType(Context.getType("doom.Node.Nodes")),
          opt: false
        });
        constructorArgs.push(macro $i{CHILDREN_IDENT});
      case Optional:
        withArgs.push({
          name: CHILDREN_IDENT,
          type: TypeTools.toComplexType(Context.getType("doom.Node.Nodes")),
          opt: true
        });
        constructorArgs.push(macro $i{CHILDREN_IDENT});
    }
    var localClass = Context.getLocalClass().get();
    var instance = {
          expr : ENew({
            sub: null, // Null<String>
            params: [], // Array<TypeParam>
            pack: localClass.pack,
            name: localClass.name
          },
            constructorArgs
          ),
          pos : Context.currentPos()
        };
    withExprs.push(macro return $e{instance});

    // "with" field
    return {
      pos: Context.currentPos(),
      name: WITH_IDENT,
      meta: null,
      kind: FFun({
        ret: macro : doom.Node,
        expr: macro $b{withExprs},
        args: withArgs,
      }),
      access: [AStatic, APublic]
    };
  }

  // public function new(api : ApiType, state : StateType, ?children : Nodes) {
  //   this.api = api;
  //   this.state = state;
  //   // if children
  //   this.children = children
  //   super();
  // }
  static function generateConstructor(options: {
    childrenMeta : ChildrenMeta,
    apiMeta: FieldsMeta,
    apiComplexType : ComplexType,
    stateMeta: FieldsMeta,
    stateComplexType : ComplexType,
  }) : Field {
    // With the constructor body expression
    var constructorExprs : Array<Expr> = [];

    // Add expressions to assign default state values for any state field with a default
    var stateMetas = switch options.stateMeta {
      case None: [];
      case Only(fieldMeta) : [fieldMeta];
      case Many(fieldMetas) : fieldMetas;
    };
    for (fieldMeta in stateMetas) {
      if (!fieldMeta.isRequired && fieldMeta.hasDefaultValue) {
        var fieldName = fieldMeta.field.name;
        var expr : Expr = macro if (state.$fieldName == null) state.$fieldName = $e{fieldMeta.defaultValue};
        constructorExprs.push(expr);
      }
    }
    constructorExprs = constructorExprs.concat([
      macro this.api = api,
      macro this.state = state,
    ]);
    switch options.childrenMeta {
      case None: // no-op
      case Optional | Required: constructorExprs.push(macro this.children = children);
    };
    switch options.childrenMeta {
      case None: // no-op
        constructorExprs.push(macro super(null));
      case Optional, Required:
        constructorExprs.push(macro super($i{CHILDREN_IDENT}));
    }

    var constructorExpr : Expr = macro $b{constructorExprs};

    //trace(ExprTools.toString(constructorExpr));

    // With the constructor args
    var constructorArgs : Array<FunctionArg> = [];
    constructorArgs.push({
      name: API_IDENT,
      type: options.apiComplexType
    });
    constructorArgs.push({
      name: STATE_IDENT,
      type: options.stateComplexType
    });
    switch options.childrenMeta {
      case None: // no-op
      case Optional: constructorArgs.push({
        name: CHILDREN_IDENT,
        opt: true,
        type: macro : doom.Node.Nodes
      });
      case Required: constructorArgs.push({
        name: CHILDREN_IDENT,
        type: macro : doom.Node.Nodes
      });
    }

    // "new" field
    return {
      pos: Context.currentPos(),
      name: NEW_IDENT,
      meta: null,
      kind: FFun({
        ret: null,
        expr: constructorExpr,
        args: constructorArgs,
      }),
      access: [APublic]
    };
  }

  static function generateWithFunction(options: {
    childrenMeta: ChildrenMeta,
    apiComplexType: ComplexType,
    apiMeta: FieldsMeta,
    stateComplexType: ComplexType,
    stateMeta: FieldsMeta
  }) : Field {
    return null;
  }

  // change:
  // @api public var myApi : Void -> Void;
  //
  // to:
  // public var myApi(get, null) : Void -> Void;
  //
  // function get_myApi() : Void -> Void {
  //   return api.myApi;
  // }
  static function changeFieldsToProperties(fields : Array<Field>, meta : FieldsMeta, name : String) : Void {
    var fieldMetas = switch meta {
      case None: [];
      case Only(fieldMeta) : [fieldMeta];
      case Many(fieldMetas) : fieldMetas;
    };
    for (fieldMeta in fieldMetas) {
      var field = fieldMeta.field;
      var originalKind = switch field.kind {
        case FieldType.FVar(t, e) : { type: t, expr: e };
        case FieldType.FProp(g, s, t, e) : null;
        case FieldType.FFun(f) : null;
      };
      if (originalKind == null) Context.error('AutoComponent: cannot convert $name field ${field.name} to getter property', field.pos);
      fields.remove(field);
      var propField : Field = {
        pos: Context.currentPos(),
        name: field.name,
        meta: null,
        kind: FProp("get", "null", originalKind.type, originalKind.expr),
        doc: field.doc,
        access: field.access,
      };
      fields.push(propField);
      var fieldParts : Array<String> = [name, field.name];
      var bodyExprs :Array<Expr> = [
        macro return $p{fieldParts},
      ];
      var getterFunctionField : Field = {
        pos: Context.currentPos(),
        name: 'get_${field.name}',
        meta: null,
        kind: FFun({
          ret: originalKind.type, // Null<ComplexType>
          params: [], // Null<Array<TypeParamDecl>>
          expr: macro $b{bodyExprs}, // Null<Expr>
          args: [], // Array<FunctionArg>
        }),
        doc: null,
        access: [APrivate, AInline],
      }
      fields.push(getterFunctionField);
    }
  }

  // public function update(newState : State) {
  //   var oldState = this.state;
  //   this.state = newState;
  //   if(!shouldRender(oldState, newState))
  //     return;
  //   updateNode(node);
  // }
  static function generateUpdateFunction(options: { stateComplexType: ComplexType }) : Field {
    return {
      pos: Context.currentPos(),
      name: UPDATE_IDENT,
      meta: null,
      doc: null,
      access: [APublic],
      kind: FFun({
        ret: null,
        params: [],
        expr: macro {
          var oldState = this.state;
          this.state = newState;
          if (!shouldRender(oldState, newState)) return;
          updateNode(node);
        },
        args: [{
          value: null, // Null<Null<Expr>>
          type: options.stateComplexType, // Null<ComplexType>
          opt: false, // Null<Bool>
          name: "newState", // String
        }]
      }),
    };
  }

  // public function shouldRender(oldState : State, newState : State) {
  //   return true;
  // }
  static function generateShouldRenderFunction(options: { stateComplexType: ComplexType }) : Field {
    return {
      pos: Context.currentPos(),
      name: SHOULD_RENDER_IDENT,
      meta: null,
      doc: null,
      access: [APublic],
      kind: FFun({
        ret: null,
        params: [],
        expr: macro {
          return true;
        },
        args: [{
          value: null, // Null<Null<Expr>>
          type: options.stateComplexType, // Null<ComplexType>
          opt: false, // Null<Bool>
          name: "oldState", // String
        }, {
          value: null, // Null<Null<Expr>>
          type: options.stateComplexType, // Null<ComplexType>
          opt: false, // Null<Bool>
          name: "newState", // String
        }]
      }),
    };
  }

  static function fullyQualifyFieldTypes(fields : Array<Field>) : Array<Field> {
    return fields.map(fullyQualifyFieldType);
  }

  static function fullyQualifyFieldType(field : Field) : Field {
    return switch field.kind {
      case FVar(complexType, expr) :
        field.kind = FVar(fullyQualifyComplexType(complexType), expr);
        field;
      case _ : field;
    };
  }

  static function fullyQualifyComplexTypes(complexTypes : Array<ComplexType>) : Array<ComplexType> {
    return complexTypes.map(fullyQualifyComplexType);
  }

  static function fullyQualifyComplexType(complexType : ComplexType) : ComplexType {
    return switch complexType {
      case TPath({ name: "Void" }) : complexType;
      case TPath({ name: "Null", params: params, pack: pack, sub: sub }) : TPath({
        name: "Null",
        params: fullyQualifyTypeParams(params),
        pack: pack,
        sub: sub,
      });
      case TPath(p) :
        var complexTypeString = ComplexTypeTools.toString(complexType);
        var type = Context.getType(complexTypeString);
        TypeTools.toComplexType(type);
      case TFunction(args, ret) : TFunction(fullyQualifyComplexTypes(args), fullyQualifyComplexType(ret));
      case TAnonymous(fields) : TAnonymous(fullyQualifyFieldTypes(fields));
      case TParent(t) : TParent(fullyQualifyComplexType(t));
      case TExtend(p, fields) : TExtend(p, fullyQualifyFieldTypes(fields));
      case TOptional(t) : TOptional(fullyQualifyComplexType(t));
    };
  }

  static function fullyQualifyTypeParams(typeParams : Array<TypeParam>) : Array<TypeParam> {
    return typeParams.map(fullyQualifyTypeParam);
  }

  static function fullyQualifyTypeParam(typeParam : TypeParam) : TypeParam {
    return switch typeParam {
      case TPType(complexType) : TPType(fullyQualifyComplexType(complexType));
      case _ : typeParam;
    };
  }

  static function makeTypeOptional(type : Type) : Type {
    return ComplexTypeTools.toType(makeComplexTypeOptional(TypeTools.toComplexType(type)));
  }

  static function makeComplexTypeOptional(complexType : ComplexType) : ComplexType {
    return switch complexType {
      case TOptional(t): complexType;
      case _ : TOptional(complexType);
    };
  }

  static function makeFieldTypeOptional(field : Field) : Field {
    field.meta.push({
      name: ":optional",
      pos: Context.currentPos(),
      params: null
    });
    return field;
  }

  static function addFieldDefaultValue(field : Field, defaultValueExpr : Expr) : Field {
    switch field.kind {
      case FieldType.FVar(complexType, _) :
        field.kind = FieldType.FVar(complexType, defaultValueExpr);
      case _ : // no-op
    };
    return field;
  }

  static function hasFieldByName(fields : Array<Field>, name : String) : Bool {
    for (field in fields) {
      if (field.name == name) return true;
    }
    return false;
  }
}

enum ChildrenMeta {
  None;
  Required;
  Optional;
}

typedef FieldMeta = {
  field: Field,
  isRequired: Bool,
  hasDefaultValue: Bool,
  defaultValue: Expr,
};

enum FieldsMeta {
  None;
  Only(fieldMeta : FieldMeta);
  Many(fieldMetas : Array<FieldMeta>);
}
