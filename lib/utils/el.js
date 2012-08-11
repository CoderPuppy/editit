// Generated by CoffeeScript 1.3.3
(function() {

  define(function(require, exports, module) {
    var height, measure, num, width;
    num = require('./num');
    exports.width = width = function(el) {
      el = $(el);
      return num.to(el.css('margin-left')) + num.to(el.css('border-left-size')) + num.to(el.css('width')) + num.to(el.css('border-right-size')) + num.to(el.css('margin-right'));
    };
    exports.height = height = function(el) {
      el = $(el);
      return num.to(el.css('margin-top')) + num.to(el.css('border-top-size')) + num.to(el.css('width')) + num.to(el.css('border-bottom-size')) + num.to(el.css('margin-bottom'));
    };
    exports.measure = measure = function(el) {
      return {
        height: height(el),
        width: width(el)
      };
    };
    return exports;
  });

}).call(this);