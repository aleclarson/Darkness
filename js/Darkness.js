var Tappable, Type, View, frozen, type;

frozen = require("Property").frozen;

View = require("modx/views").View;

Type = require("modx").Type;

Tappable = require("tappable");

type = Type("Darkness");

type.defineOptions({
  value: Number,
  minValue: Number.withDefault(0),
  maxValue: Number.withDefault(1),
  ignoreTouches: Boolean.withDefault(false),
  easing: Function
});

type.defineFrozenValues(function(options) {
  return {
    minValue: options.minValue,
    maxValue: options.maxValue
  };
});

type.defineReactiveValues(function(options) {
  return {
    ignoreTouches: options.ignoreTouches
  };
});

type.defineNativeValues(function(options) {
  var ref;
  return {
    _opacity: (ref = options.value) != null ? ref : options.minValue
  };
});

type.defineNativeValues({
  _pointerEvents: function() {
    if (this.ignoreTouches) {
      return "none";
    }
    if (this._opacity.value === 0) {
      return "none";
    }
    return "auto";
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
