
Darkness = require "./Darkness"

module.exports = Component "DarknessView",

  propTypes:
    darkness: Darkness

  customValues:

    darkness: get: ->
      @props.darkness

    opacity: get: ->
      @darkness._opacity

    onPress: get: ->
      @darkness.onPress

  initNativeValues: ->

    pointerEvents: =>
      isTouchable = @onPress? and @opacity.value > 0
      if isTouchable then "auto" else "none"

  render: ->

    darkness = View {
      @pointerEvents
      style: {
        @opacity
        top: 0
        left: 0
        right: 0
        bottom: 0
        backgroundColor: "#000"
        position: "absolute"
      }
    }

    return darkness unless @onPress?

    return Touchable {
      @onPress
      children: darkness
    }
