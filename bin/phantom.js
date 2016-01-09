var page = require('webpage').create();
page.onConsoleMessage = function (msg) { console.log(msg); };
var url = './bin/index.html';

page.open(url, function (status) {
  function check() {
    return page.evaluate(function() { return window.utest_result; });
  }
  function poll(callback) {
    var result = check();
    if(result) {
      return callback(result);
    }
    setTimeout(function() { poll(callback); }, 1000);
  }
  poll(function(result) {
    if(result.isOk) {
      console.log('phantom.js: test successful');
      console.log(result.message);
      phantom.exit();
    } else {
      console.log('phantom.js: test errors');
      console.log(result.message);
      phantom.exit(1);
    }
  });
});
