package todomvc.data;

enum TodoAction {
  Add(text : String);
  Toggle(id : String);
  Remove(id : String);
  SetVisibilityFilter(filter : VisibilityFilter);
  UpdateText(id : String, text : String);
  ClearCompleted;
  ToggleAll;
}
