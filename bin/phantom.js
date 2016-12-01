var system = require('system');
var page = require('webpage').create();
page.onConsoleMessage = function (serialized) {
  // var args = JSON.parse(serialized);
  // console.log.call(console, args);
  console.log(serialized);
};
page.onError = function(msg, trace) {
  var msgStack = ['ERROR: ' + msg];
  if (trace && trace.length) {
    msgStack.push('TRACE:');
    trace.forEach(function(t) {
      msgStack.push(' -> ' + t.file + ': ' + t.line + (t.function ? ' (in function "' + t.function +'")' : ''));
    });
  }
  system.stderr.write(msgStack.join('\n'));
};
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
