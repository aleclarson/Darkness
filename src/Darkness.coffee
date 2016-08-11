
{frozen} = require "Property"
{View} = require "modx/views"
{Type} = require "modx"

fromArgs = require "fromArgs"
Tappable = require "tappable"

type = Type "Darkness"

type.defineOptions
  value: Number
  minValue: Number.withDefault 0
  maxValue: Number.withDefault 1
  ignoreTouches: Boolean.withDefault no
  easing: Function

type.defineFrozenValues

  minValue: fromArgs "minValue"

  maxValue: fromArgs "maxValue"

type.defineReactiveValues

  ignoreTouches: fromArgs "ignoreTouches"

type.defineNativeValues

  _opacity: (options) ->
    return options.value if options.value isnt undefined
    return options.minValue

  _pointerEvents: -> =>
    return "none" if @ignoreTouches
    return "none" if @_opacity.value is 0
    return "auto"

type.defineGetters

  didTap: -> @_tap.didTap

  _tap: ->
    value = Tappable { maxTapCount: 1 }
    frozen.define this, "_tap", { value }
    return value

type.definePrototype

  value:
    get: -> @_opacity.value
    set: (newValue) ->
      @_opacity.value = newValue

  progress:
    get: -> @_opacity.progress
    set: (newValue) ->
      @_opacity.progress = newValue

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

type.willMount ->
  @_opacity.willProgress
    fromValue: @minValue
    toValue: @maxValue

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
