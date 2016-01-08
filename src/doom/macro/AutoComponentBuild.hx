package doom.macro;

import haxe.macro.ComplexTypeTools;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;
using haxe.macro.ExprTools;

class AutoComponentBuild {
  // field names
  static inline var CHILDREN_IDENT = 'children';
  static inline var STATE_IDENT = 'state';
  static inline var API_IDENT = 'api';
  static inline var NEW_IDENT = 'new';
  static inline var CREATE_IDENT = 'create';
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
    var apiMeta = getApiMeta(fields);
    var stateMeta = getStateMeta(fields);

    // Generate the State and Api modules/types from the state/api metadata
    //trace('generateApiModule');
    var apiComplexType = generateApiModule({ localClass: localClass, apiMeta: apiMeta });

    //trace('generateStateModule');
    var stateComplexType = generateStateModule({ localClass: localClass, stateMeta: stateMeta });

    // Add "api" field to class
    //trace('generateApiField');
    fields.push(generateApiField({
      apiComplexType: apiComplexType,
    }));

    // Add "state" field to class
    //trace('generateStateField');
    fields.push(generateStateField({
      stateComplexType: stateComplexType,
    }));

    // Add "children" field to class (if needed)
    //trace('generateChildrenField');
    switch childrenMeta {
      case None: // no-op
      case Optional: fields.push(generateChildrenField({ required: false }));
      case Required: fields.push(generateChildrenField({ required: true }));
    };

    // Add "new" (constructor) function to class
    //trace('generateConstructor');
    fields.push(generateConstructor({
      childrenMeta: childrenMeta,
      apiMeta: apiMeta,
      apiComplexType: apiComplexType,
      stateMeta: stateMeta,
      stateComplexType: stateComplexType,
    }));

    /*
    // Add static "create" function to class
    fields.push(generateCreateFunction({
      childrenMeta: childrenMeta,
      apiMeta: apiMeta,
      apiComplexType: apiComplexType,
      stateMeta: stateMeta,
      stateComplexType: stateComplexType
    }));
    */

    // Change "@:api" vars to getter properties for api object
    changeApiFieldsToProperties(fields, apiMeta);

    // Change "@:state" vars to getter properties for state object
    changeStateFieldsToProperties(fields, stateMeta);

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

  static function getApiMeta(fields : Array<Field>) : ApiMeta {
    if (fields == null || fields.length == 0) return None;
    var stateFields = fields.filter(function(field) {
      return hasMeta(field, API_META);
    });
    if (stateFields == null || stateFields.length == 0) return None;
    return Many(fieldsToFieldMetas(stateFields, API_META));
  }

  static function getStateMeta(fields : Array<Field>) : StateMeta {
    if (fields == null || fields.length == 0) return None;
    var stateFields = fields.filter(function(field) {
      return hasMeta(field, STATE_META);
    });
    if (stateFields == null || stateFields.length == 0) return None;
    return Many(fieldsToFieldMetas(stateFields, STATE_META));
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

  static function generateApiModule(options: { localClass : ClassType, apiMeta : ApiMeta }) : ComplexType {
    var classPackages = options.localClass.pack;
    var className = options.localClass.name;
    var apiTypeName = '${className}${API_SUFFIX}';
    var modulePath : String = '${classPackages.join(".")}.${apiTypeName}';
    var apiTypeDefinition = {
      pos: Context.currentPos(),
      params: null,
      pack: [],
      name: apiTypeName,
      meta: null,
      kind: TDStructure, // TypeDefKind
      isExtern: false,
      fields: fullyQualifyFieldTypes(switch options.apiMeta {
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

  static function generateStateModule(options: { localClass: ClassType, stateMeta : StateMeta }) : ComplexType {
    var classPackages = options.localClass.pack;
    var className = options.localClass.name;
    var apiTypeName = '${className}${STATE_SUFFIX}';
    var modulePath : String = '${classPackages.join(".")}.${apiTypeName}';
    var stateTypeDefinition = {
      pos: Context.currentPos(),
      params: null,
      pack: [],
      name: apiTypeName,
      meta: null,
      kind: TDStructure, // TypeDefKind
      isExtern: false,
      fields: fullyQualifyFieldTypes(switch options.stateMeta {
        case None: [];
        case Only(fieldMeta): [fieldMetaToField(fieldMeta)];
        case Many(fieldMetas) : fieldMetasToFields(fieldMetas);
      })
    };
    var types: Array<TypeDefinition> = [stateTypeDefinition];
    var imports : Array<ImportExpr> = [];
    var usings : Array<TypePath> = [];
    Context.defineModule(modulePath, types, imports, usings);
    return TypeTools.toComplexType(Context.getType(modulePath));
  }

  static function generateApiField(options: { apiComplexType : ComplexType }) : Field {
    return {
      pos: Context.currentPos(),
      name: API_IDENT,
      meta: null,
      kind: FVar(options.apiComplexType, null),
      access: [APublic],
    };
  }

  static function generateStateField(options: { stateComplexType : ComplexType }) : Field {
    return {
      pos: Context.currentPos(),
      name: STATE_IDENT,
      meta: null,
      kind: FVar(options.stateComplexType, null),
      access: [APublic],
    };
  }

  static function generateChildrenField(options: { required : Bool }) : Field {
    return {
      pos: Context.currentPos(),
      name: CHILDREN_IDENT,
      meta: null,
      kind: options.required ?
        FVar(macro : doom.Node.Nodes, null) :
        FVar(macro : Null<doom.Node.Nodes>, null),
      access: [APublic]
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
    apiMeta: ApiMeta,
    apiComplexType : ComplexType,
    stateMeta: StateMeta,
    stateComplexType : ComplexType,
  }) : Field {
    // Create the constructor body expression
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
    constructorExprs.push(macro super());
    var constructorExpr : Expr = macro $b{constructorExprs};

    //trace(ExprTools.toString(constructorExpr));

    // Create the constructor args
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

  static function generateCreateFunction(options: {
    childrenMeta: ChildrenMeta,
    apiComplexType: ComplexType,
    apiMeta: ApiMeta,
    stateComplexType: ComplexType,
    stateMeta: StateMeta
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
  static function changeApiFieldsToProperties(fields : Array<Field>, apiMeta : ApiMeta) : Void {
    var apiFieldMetas = switch apiMeta {
      case None: [];
      case Only(fieldMeta) : [fieldMeta];
      case Many(fieldMetas) : fieldMetas;
    };
    for (apiFieldMeta in apiFieldMetas) {
      var field = apiFieldMeta.field;
      var originalKind = switch field.kind {
        case FieldType.FVar(t, e) : { type: t, expr: e };
        case FieldType.FProp(g, s, t, e) : null;
        case FieldType.FFun(f) : null;
      };
      if (originalKind == null) Context.error('AutoComponent: cannot convert api field ${field.name} to getter property', field.pos);
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
      var fieldParts : Array<String> = ["api", field.name];
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
        access: [APrivate],
      }
      fields.push(getterFunctionField);
    }
  }

  static function changeStateFieldsToProperties(fields : Array<Field>, stateMeta : StateMeta) : Void {
    var stateFieldMetas = switch stateMeta {
      case None: [];
      case Only(fieldMeta) : [fieldMeta];
      case Many(fieldMetas) : fieldMetas;
    };
    for (stateFieldMeta in stateFieldMetas) {
      var field = stateFieldMeta.field;
      var originalKind = switch field.kind {
        case FieldType.FVar(t, e) : { type: t, expr: e };
        case FieldType.FProp(g, s, t, e) : null;
        case FieldType.FFun(f) : null;
      };
      if (originalKind == null) Context.error('AutoComponent: cannot convert state field ${field.name} to getter property', field.pos);
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
      var fieldParts : Array<String> = ["state", field.name];
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
        access: [APrivate],
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

enum StateMeta {
  None;
  Only(fieldMeta : FieldMeta);
  Many(fieldMetas : Array<FieldMeta>);
}

enum ApiMeta {
  None;
  Only(fieldMeta : FieldMeta);
  Many(fieldMetas : Array<FieldMeta>);
}
