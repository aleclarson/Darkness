
{frozen} = require "Property"
{View} = require "modx/views"
{Type} = require "modx"

Tappable = require "tappable"
isType = require "isType"
steal = require "steal"

type = Type "Darkness"

type.defineOptions
  value: Number
  minValue: Number.withDefault 0
  maxValue: Number.withDefault 1
  ignoreTouches: Boolean.withDefault no
  easing: Function

type.defineFrozenValues (options) ->

  minValue: options.minValue

  maxValue: options.maxValue

type.defineReactiveValues (options) ->

  ignoreTouches: options.ignoreTouches

type.defineNativeValues (options) ->

  _opacity: options.value ? options.minValue

type.defineNativeValues

  _pointerEvents: ->
    return "none" if @ignoreTouches
    return "none" if @_opacity.value is 0
    return "auto"

type.initInstance ->
  @_opacity.willProgress
    fromValue: @minValue
    toValue: @maxValue

type.defineGetters

  didTap: -> @_tap.didTap.listenable

  _tap: ->
    value = Tappable()
    frozen.define this, "_tap", {value}
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
    progress = steal config, "progress"
    if isType progress, Number
      config.endValue = @minValue + progress * (@maxValue - @minValue)
    @_opacity.animate config

  stopAnimation: ->
    @_opacity.stopAnimation()

#
# Rendering
#

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
