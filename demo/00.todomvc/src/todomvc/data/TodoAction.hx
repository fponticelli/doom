package todomvc.data;

enum TodoAction {
  Add(text : String);
  Toggle(index : Int);
  Remove(index : Int);
  SetVisibilityFilter(filter : VisibilityFilter);
  UpdateText(index : Int, text : String);
  ClearCompleted;
  ToggleAll;
}
