var NativeValue, Touchable, View, Void, emptyFunction, ref;

ref = require("component"), NativeValue = ref.NativeValue, Touchable = ref.Touchable, View = ref.View;

Void = require("type-utils").Void;

emptyFunction = require("emptyFunction");

module.exports = Factory("Darkness", {
  optionTypes: {
    opacity: Number,
    range: Array,
    easing: [Function, Void],
    within: [Array, Void],
    onPress: [Function, Void]
  },
  optionDefaults: {
    opacity: 0
  },
  customValues: {
    minOpacity: {
      get: function() {
        return this.range[0];
      }
    },
    maxOpacity: {
      get: function() {
        return this.range[1];
      }
    },
    opacity: {
      get: function() {
        return this._opacity.value;
      },
      set: function(value) {
        return this._opacity.value = value;
      }
    },
    progress: {
      get: function() {
        return this._opacity.getProgress({
          from: this.minOpacity,
          to: this.maxOpacity
        });
      },
      set: function(progress) {
        return this._opacity.setProgress({
          progress: progress,
          from: this.minOpacity,
          to: this.maxOpacity
        });
      }
    },
    easing: {
      get: function() {
        return this._opacity._easing;
      },
      set: function(easing) {
        return this._opacity._easing = easing;
      }
    },
    within: {
      get: function() {
        return this._opacity._inputRange;
      },
      set: function(inputRange) {
        return this._opacity._inputRange = inputRange;
      }
    },
    _component: {
      lazy: function() {
        return require("./DarknessView");
      }
    }
  },
  initReactiveValues: function(options) {
    return {
      onPress: options.onPress
    };
  },
  initFrozenValues: function(options) {
    return {
      range: options.range,
      _opacity: NativeValue(options.opacity)
    };
  },
  init: function(options) {
    var base;
    this._opacity.type = Number;
    if ((base = this._opacity).value == null) {
      base.value = this.minOpacity;
    }
    this.easing = options.easing;
    return this.within = options.within;
  },
  animate: function(options) {
    return this._opacity.animate(options);
  },
  render: function() {
    return this._component({
      darkness: this
    });
  }
});

//# sourceMappingURL=../../map/src/Darkness.map
