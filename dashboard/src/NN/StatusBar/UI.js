'use strict';

exports.setInterval = function(msec) {
  return function(action) {
    setInterval(function() {
      action();
    }, msec);
  };
};
