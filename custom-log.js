// Generated by CoffeeScript 1.9.1
(function() {
  "use strict";
  var customLog,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  customLog = function(init) {
    var Log, fn, level, log, message, prefixMsg;
    Log = (function() {
      function Log(level1, message1) {
        var name, prop;
        this.level = level1 != null ? level1 : 'log';
        this.message = message1 != null ? message1 : '';
        this.enable = bind(this.enable, this);
        this.disable = bind(this.disable, this);
        this.enabled = true;
        this.log = (function(_this) {
          return function() {
            var ref;
            if (_this.enabled) {
              return console.log((ref = _this.message).concat.apply(ref, arguments));
            }
          };
        })(this);
        for (name in this) {
          prop = this[name];
          if ((this.hasOwnProperty(name)) && (name !== 'log')) {
            this.log[name] = prop;
          }
        }
      }

      Log.prototype.disable = function() {
        this.enabled = false;
        return console.log('CUSTOM-LOG: ' + this.level + ' has been disabled.');
      };

      Log.prototype.enable = function() {
        this.enabled = true;
        return console.log('CUSTOM-LOG: ' + this.level + ' is now enabled.');
      };

      return Log;

    })();
    if (typeof init === 'string') {
      prefixMsg = init;
    }
    log = new Log('log', prefixMsg).log;
    if (typeof init === 'object') {
      fn = function(level, message) {
        if (level === 'log') {
          return log = new Log(level, message).log;
        } else {
          return log[level] = new Log(level, message).log;
        }
      };
      for (level in init) {
        message = init[level];
        fn(level, message);
      }
    }
    return log;
  };

  if ((typeof define !== "undefined" && define !== null) && ('function' === typeof define) && define.amd) {
    define('customLog', [], function() {
      return customLog;
    });
  } else if (typeof module !== 'undefined') {
    module.exports = customLog;
  } else if (typeof window !== 'undefined') {
    window.customLog = customLog;
  }

}).call(this);
