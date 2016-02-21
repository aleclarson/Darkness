var NativeValue, Touchable, View, Void, ref;

ref = require("component"), NativeValue = ref.NativeValue, Touchable = ref.Touchable, View = ref.View;

Void = require("type-utils").Void;

module.exports = Factory("Darkness", {
  optionTypes: {
    opacity: Number,
    range: Array,
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
        assertType(value, Number);
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
        assertType(progress, Number);
        return this._opacity.setProgress({
          progress: progress,
          from: this.minOpacity,
          to: this.maxOpacity
        });
      }
    },
    onPress: {
      value: null,
      reactive: true,
      didSet: function() {}
    },
    _component: {
      lazy: function() {
        return require("./DarknessView");
      }
    }
  },
  initValues: function(options) {
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
  init: function() {
    var base;
    return (base = this._opacity).value != null ? base.value : base.value = this.minOpacity;
  },
  render: function() {
    return this._component({
      darkness: this
    });
  }
});

//# sourceMappingURL=../../map/src/Darkness.map
