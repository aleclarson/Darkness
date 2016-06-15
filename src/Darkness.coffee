
{ Component, View } = require "component"

Tappable = require "tappable"

type = Component.Type "Darkness"

type.defineOptions

  value:
    type: Number
    required: no

  minValue:
    type: Number
    default: 0

  maxValue:
    type: Number
    default: 1

  ignoreTouches:
    type: Boolean
    default: no

  easing:
    type: Function
    required: no

type.defineFrozenValues

  minValue: getArgProp "minValue"

  maxValue: getArgProp "maxValue"

  _tap: ->
    return Tappable
      maxTapCount: 1

type.defineReactiveValues

  ignoreTouches: getArgProp "ignoreTouches"

type.defineNativeValues

  _opacity: (options) ->
    return options.value if options.value isnt undefined
    return options.minValue

  _pointerEvents: -> =>
    return "none" if @ignoreTouches
    return "none" if @_opacity.value is 0
    return "auto"

type.initInstance (options) ->
  @_opacity.willProgress
    fromValue: options.minValue
    toValue: options.maxValue

type.definePrototype

  value:
    get: -> @_opacity.value
    set: (newValue) ->
      @_opacity.value = newValue

  didTap: get: ->
    @_tap.didTap

type.defineMethods

  animate: (config) ->
    @_opacity.animate config

  stopAnimation: ->
    @_opacity.stopAnimation()

type.shouldUpdate ->
  return no

type.render ->
  return View
    style: @styles.container()
    pointerEvents: @_pointerEvents
    mixins: [ @_tap.touchHandlers ]

type.defineStyles

  container:
    position: "absolute"
    top: 0
    left: 0
    right: 0
    bottom: 0
    backgroundColor: "#000"
    opacity: -> @_opacity

module.exports = type.build()
