


var dom = div([cls % "greetings"], "hello");
Doom.mount(element, dom, unit);

var dom = render(v -> div([cls % v.cls], v.text)); // build on top of component
Doom.mount(element, dom, { cls: "greetings", text: "world" });

var dom = comp((value, update) -> // build on top of component
  var increment = update.bind(value+1),
      decrement = update.bind(value-1);
  div([
    button([click % increment], "+"),
    span(value),
    button([click % decrement], "-")
  ])
);
Doom.mount(element, dom, 0);

var dom = inst("", (value, update) -> // `inst` is not a great name, build on top of component
  div([cls % "greetings"], [
    span("hello: "),
    input([value % value], input(e -> update(e.value))),
    span('your capitalized name is $value')
  ])
);
Doom.mount(element, dom, unit);

var dom = store(
  (state, dispatch) -> form(
    label([
      "name: ", input(value % state.name)
    ]),
    label([
      "points: ", input(value % state.points)
    ]),
    button(submit % () -> dispatch(...), "submit") // <-- ????
  ),
  (state, action) -> ,
  (state, action, dispatch) -> ... make ajax call to save data
);
Doom.mount(element, dom, { name: "Franco", points: 1000 });


enum Node<T, E> {
  Element<Element>(
    tag: String,
    attributes: ReadonlyArray<Attribute>,
    children: ReadonlyArray<Node>): Node<Unit, Element>;
  NSElement<Element>(
    ns: String,
    tag: String,
    attributes: ReadonlyArray<Attribute>,
    children: ReadonlyArray<Node>): Node<Unit, Element>;
  Text<Element>(text: String): Node<Unit, Element>;
  Comment<Element>(comment: String): Node<Unit, Element>;

  Component<State, Action, Out, Element>(
    f: State -> (Action -> Void) -> Node<Out>,
    reduce: State -> Action -> Option<State>, // option to avoid useless rerenders?
    middleware: State -> Action -> (Action -> Void) -> Void
  ): Node<State, Element>;
}

enum Attribute {
  TextAttribute(attr: TextAttribute, value: String);
  BooleanAttribute(attr: BooleanAttribute, value: Bool);
  BooleanProperty(attr: BooleanProperty, value: Bool);
  PositiveNumericAttribute(attr: PositiveNumericAttribute, value: Float);
  NumericAttribute(attr: NumericAttribute, value: Float);
  OverloadedBooleanAttribute(attr: OverloadedBooleanAttribute, value: Bool); // ?
  SideEffectProperty(attr: SideEffectProperty, value: Float);

  KeyboardEvent(event: KeyboardEvent, handler: HtmlKeyboardEvent -> Void); // ?
}

enum KeyboardEvent {
  KeyDown; KeyUp; Input; // ...
}

enum TextAttribute {
  About; Accept; AcceptCharset; AccessKey; Action; AllowTransparency; Alt; AutoCapitalize; AutoComplete; AutoCorrect; AutoSave; CellPadding; CellSpacing; Challenge; CharSet; ClassID; ClassName; Color; ColSpan; Content; ContextMenu; Coords; CrossOrigin; Data; Datatype; DateTime; Dir; Draggable; EncType; Form; FormAction; FormEncType; FormMethod; FormTarget; FrameBorder; Headers; Height; High; Href; HrefLang; HtmlFor; HttpEquiv; Icon; Id; Inlist; InputMode; Integrity; Is; ItemID; ItemProp; ItemRef; ItemType; KeyParams; KeyType; Kind; Label; Lang; List; Low; Manifest; MarginHeight; MarginWidth; Max; MaxLength; Media; MediaGroup; Method; Min; MinLength; Name; Nonce; Optimum; Pattern; Placeholder; Poster; Prefix; Preload; Profile; Property; RadioGroup; Rel; Resource; Results; Role; Sandbox; Scope; Scrolling; Security; Shape; Sizes; SpellCheck; Src; SrcDoc; SrcLang; SrcSet; Step; Style; Summary; TabIndex; Target; Title; Type; Typeof; Unselectable; UseMap; Vocab; Width; Wmode; Wrap;
}

enum BooleanAttribute {
  AllowFullScreen; Async; AutoFocus; AutoPlay; Capture; ContentEditable; Controls; Default; Defer; Disabled; FormNoValidate; Hidden; Loop; NoValidate; Open; ReadOnly; Required; Reversed; Scoped; Seamless; ItemScope;
}

enum BooleanProperty {
  Checked; Multiple; Muted; Selected;
}

enum PositiveNumericAttribute {
  Cols; Rows; Size; Span;
}

enum NumericAttribute {
  RowSpan; Start;
}

enum OverloadedBooleanAttribute {
  Donwload;
}

enum SideEffectProperty {
  Value;
}
