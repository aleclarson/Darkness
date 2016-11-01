
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

type.defineFrozenValues (options) ->

  minValue: options.minValue

  maxValue: options.maxValue

type.defineReactiveValues (options) ->

  ignoreTouches: options.ignoreTouches

type.defineNativeValues (options) ->

  opacity: options.value ? options.minValue

type.defineNativeValues

  _pointerEvents: ->
    return "none" if @ignoreTouches
    return "none" if @opacity.value is 0
    return "auto"

type.defineGetters

  didTap: -> @_tap.didTap.listenable

  _tap: ->
    value = Tappable()
    frozen.define this, "_tap", {value}
    return value

type.definePrototype

  value:
    get: -> @opacity.value
    set: (value) ->
      @opacity.value = value

  progress:
    get: -> (@opacity.value - @minValue) / (@maxValue - @minValue)
    set: (progress) ->
      @opacity.value = @minValue + progress * (@maxValue - @minValue)

type.defineMethods

  animate: (config) ->

    progress = steal config, "progress"
    if isType progress, Number
      config.endValue = @minValue + progress * (@maxValue - @minValue)

    @opacity.animate config

  stopAnimation: ->
    @opacity.stopAnimation()

#
# Rendering
#

type.render ->
  return View
    style: @styles.container()
    pointerEvents: @_pointerEvents
    mixins: [
      @_tap.touchHandlers
    ]

type.defineStyles

  container:
    cover: yes
    backgroundColor: "#000"
    opacity: -> @opacity

module.exports = type.build()
