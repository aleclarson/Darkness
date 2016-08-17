var Tappable, Type, View, fromArgs, frozen, type;

frozen = require("Property").frozen;

View = require("modx/views").View;

Type = require("modx").Type;

fromArgs = require("fromArgs");

Tappable = require("tappable");

type = Type("Darkness");

type.defineOptions({
  value: Number,
  minValue: Number.withDefault(0),
  maxValue: Number.withDefault(1),
  ignoreTouches: Boolean.withDefault(false),
  easing: Function
});

type.defineFrozenValues({
  minValue: fromArgs("minValue"),
  maxValue: fromArgs("maxValue")
});

type.defineReactiveValues({
  ignoreTouches: fromArgs("ignoreTouches")
});

type.defineNativeValues({
  _opacity: function(options) {
    if (options.value !== void 0) {
      return options.value;
    }
    return options.minValue;
  },
  _pointerEvents: function() {
    return (function(_this) {
      return function() {
        if (_this.ignoreTouches) {
          return "none";
        }
        if (_this._opacity.value === 0) {
          return "none";
        }
        return "auto";
      };
    })(this);
  }
});

type.initInstance(function() {
  return this._opacity.willProgress({
    fromValue: this.minValue,
    toValue: this.maxValue
  });
});

type.defineGetters({
  didTap: function() {
    return this._tap.didTap;
  },
  _tap: function() {
    var value;
    value = Tappable({
      maxTapCount: 1
    });
    frozen.define(this, "_tap", {
      value: value
    });
    return value;
  }
});

type.definePrototype({
  value: {
    get: function() {
      return this._opacity.value;
    },
    set: function(newValue) {
      return this._opacity.value = newValue;
    }
  },
  progress: {
    get: function() {
      return this._opacity.progress;
    },
    set: function(newValue) {
      return this._opacity.progress = newValue;
    }
  }
});

type.defineMethods({
  animate: function(config) {
    return this._opacity.animate(config);
  },
  stopAnimation: function() {
    return this._opacity.stopAnimation();
  }
});

type.shouldUpdate(function() {
  return false;
});

type.render(function() {
  return View({
    style: this.styles.container(),
    pointerEvents: this._pointerEvents,
    mixins: [this._tap.touchHandlers]
  });
});

type.defineStyles({
  container: {
    position: "absolute",
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: "#000",
    opacity: function() {
      return this._opacity;
    }
  }
});

module.exports = type.build();

//# sourceMappingURL=map/Darkness.map
