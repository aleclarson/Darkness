
{ NativeValue, View, Component } = require "component"

Tappable = require "tappable"

module.exports =
Darkness = Factory "Darkness",

  kind: NativeValue

  optionTypes:
    value: Number.Maybe
    minValue: Number
    maxValue: Number
    ignoreTouches: Boolean

  optionDefaults:
    minValue: 0
    maxValue: 1
    ignoreTouches: no

  create: (options) ->
    NativeValue options.value ?= options.minValue

  initFrozenValues: ->

    tap: Tappable
      maxTapCount: 1

  initReactiveValues: (options) ->

    ignoreTouches: options.ignoreTouches

  init: (options) ->

    @willProgress
      fromValue: options.minValue
      toValue: options.maxValue

  render: ->
    return Darkness.View
      darkness: this

  _createPointerEvents: ->
    return NativeValue =>
      return "none" if @ignoreTouches
      return "none" if @value is 0
      return "auto"

Darkness.View = Component "DarknessView",

  initNativeValues: ->

    pointerEvents: @props.darkness._createPointerEvents()

  shouldComponentUpdate: ->
    return no

  render: ->
    return View {
      @pointerEvents
      style: {
        opacity: @props.darkness
        top: 0
        left: 0
        right: 0
        bottom: 0
        backgroundColor: "#000"
        position: "absolute"
      }
      mixins: [
        @props.darkness.tap.touchHandlers
      ]
    }
