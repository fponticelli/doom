package todomvc.data;

enum TodoAction {
  Add(text : String);
  Complete(index : Int);
  SetVisibilityFilter(filter : VisibilityFilter);
  ClearCompleted;
  ToggleCheck;
}
