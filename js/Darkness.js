var Component, Tappable, View, fromArgs, ref, type;

ref = require("component"), Component = ref.Component, View = ref.View;

fromArgs = require("fromArgs");

Tappable = require("tappable");

type = Component.Type("Darkness");

type.defineOptions({
  value: {
    type: Number,
    required: false
  },
  minValue: {
    type: Number,
    "default": 0
  },
  maxValue: {
    type: Number,
    "default": 1
  },
  ignoreTouches: {
    type: Boolean,
    "default": false
  },
  easing: {
    type: Function,
    required: false
  }
});

type.defineFrozenValues({
  minValue: fromArgs("minValue"),
  maxValue: fromArgs("maxValue"),
  _tap: function() {
    return Tappable({
      maxTapCount: 1
    });
  }
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

type.initInstance(function(options) {
  return this._opacity.willProgress({
    fromValue: options.minValue,
    toValue: options.maxValue
  });
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
  didTap: {
    get: function() {
      return this._tap.didTap;
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
