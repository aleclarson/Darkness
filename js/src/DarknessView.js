var Darkness;

Darkness = require("./Darkness");

module.exports = Component("DarknessView", {
  propTypes: {
    darkness: Darkness
  },
  customValues: {
    darkness: {
      get: function() {
        return this.props.darkness;
      }
    },
    opacity: {
      get: function() {
        return this.darkness._opacity;
      }
    },
    onPress: {
      get: function() {
        return this.darkness.onPress;
      }
    }
  },
  initNativeValues: function() {
    return {
      pointerEvents: (function(_this) {
        return function() {
          var isTouchable;
          isTouchable = (_this.onPress != null) && _this.opacity.value > 0;
          if (isTouchable) {
            return "auto";
          } else {
            return "none";
          }
        };
      })(this)
    };
  },
  render: function() {
    var darkness;
    darkness = View({
      pointerEvents: this.pointerEvents,
      style: {
        opacity: this.opacity,
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        backgroundColor: "#000",
        position: "absolute"
      }
    });
    if (this.onPress == null) {
      return darkness;
    }
    return Touchable({
      onPress: this.onPress,
      children: darkness
    });
  }
});

//# sourceMappingURL=../../map/src/DarknessView.map
