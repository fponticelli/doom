package doom;

import thx.ReadonlyArray;
import thx.Unit;

enum Node<T, E> {
  Element<Element, TC, EC>(
    tag: String,
    attributes: ReadonlyArray<Attribute>,
    children: ReadonlyArray<Node<TC, EC>>): Node<Unit, Element>;
  NSElement<Element, TC, EC>(
    ns: String,
    tag: String,
    attributes: ReadonlyArray<Attribute>,
    children: ReadonlyArray<Node<TC, EC>>): Node<Unit, Element>;
  Text<Element>(text: String): Node<Unit, Element>;
  Comment<Element>(comment: String): Node<Unit, Element>;

  Component<State, Action, Out, Element>(
    f: State -> (Action -> Void) -> Node<Out, Element>,
    reduce: State -> Action -> Option<State>, // option to avoid useless rerenders?
    middleware: State -> Action -> (Action -> Void) -> Void
  ): Node<State, Element>;
}
