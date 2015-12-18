import utest.Assert;

import Doom.*;

class TestDoom {
  public function new() {}

  public function testD() {
    var result = D('button[type=button].btn.btn-primary', "My button");
    Assert.notNull(result);
  }
}
