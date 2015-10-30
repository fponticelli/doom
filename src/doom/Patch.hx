package doom;

enum Patch {
  ContentChanged(newcontent : String);
  PatchChild(index : Int, patch : Patch);
}
