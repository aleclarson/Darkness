var Component, Darkness, NativeValue, Tappable, View, ref;

ref = require("component"), NativeValue = ref.NativeValue, View = ref.View, Component = ref.Component;

Tappable = require("tappable");

module.exports = Darkness = Factory("Darkness", {
  kind: NativeValue,
  optionTypes: {
    value: Number.Maybe,
    minValue: Number,
    maxValue: Number,
    ignoreTouches: Boolean
  },
  optionDefaults: {
    minValue: 0,
    maxValue: 1,
    ignoreTouches: false
  },
  create: function(options) {
    return NativeValue(options.value != null ? options.value : options.value = options.minValue);
  },
  initFrozenValues: function() {
    return {
      tap: Tappable({
        maxTapCount: 1
      })
    };
  },
  initReactiveValues: function(options) {
    return {
      ignoreTouches: options.ignoreTouches
    };
  },
  init: function(options) {
    return this.willProgress({
      fromValue: options.minValue,
      toValue: options.maxValue
    });
  },
  render: function() {
    return Darkness.View({
      darkness: this
    });
  },
  _createPointerEvents: function() {
    return NativeValue((function(_this) {
      return function() {
        if (_this.ignoreTouches) {
          return "none";
        }
        if (_this.value === 0) {
          return "none";
        }
        return "auto";
      };
    })(this));
  }
});

Darkness.View = Component("DarknessView", {
  initNativeValues: function() {
    return {
      pointerEvents: this.props.darkness._createPointerEvents()
    };
  },
  shouldComponentUpdate: function() {
    return false;
  },
  render: function() {
    return View({
      pointerEvents: this.pointerEvents,
      style: {
        opacity: this.props.darkness,
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        backgroundColor: "#000",
        position: "absolute"
      },
      mixins: [this.props.darkness.tap.touchHandlers]
    });
  }
});

//# sourceMappingURL=../../map/src/Darkness.map
