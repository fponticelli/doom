package todomvc.data;

enum TodoAction {
  Add(text : String);
  Complete(index : Int);
  SetVisibilityFilter(filter : VisibilityFilter);
  UpdateText(index : Int, text : String);
  ClearCompleted;
  ToggleCheck;
}
