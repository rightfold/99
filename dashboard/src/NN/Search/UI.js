'use strict';

exports.formatDateTime = function(msec) {
  var date = new Date(msec);
  return date.toLocaleString(['nl-NL'], {
    year: '2-digit',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
  });
};
