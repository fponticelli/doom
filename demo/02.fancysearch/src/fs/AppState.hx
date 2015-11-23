package fs;

import thx.ReadonlyArray;

enum AppState {
  Loading;
  Error(msg : String);
  Data(data : ReadonlyArray<Veggie>);
}
