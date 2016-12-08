
{AnimatedValue} = require "Animated"

TapResponder = require "TapResponder"
ReactType = require "modx/lib/Type"
isType = require "isType"
steal = require "steal"
View = require "modx/lib/View"

type = ReactType "Darkness"

type.defineOptions
  color: String.withDefault "#000"
  value: Number
  minValue: Number.withDefault 0
  maxValue: Number.withDefault 1
  ignoreTouches: Boolean.withDefault no
  isNative: Boolean.withDefault no
  tap: TapResponder

type.defineValues (options) ->

  _tap: options.tap

type.defineFrozenValues (options) ->

  color: options.color

  minValue: options.minValue

  maxValue: options.maxValue

type.defineReactiveValues (options) ->

  ignoreTouches: options.ignoreTouches

type.defineAnimatedValues (options) ->

  opacity: AnimatedValue options.value ? options.minValue,
    isNative: options.isNative

type.defineReactions

  _containerEvents: ->
    return "none" if @ignoreTouches
    return "none" if @opacity.get() is 0
    return "auto"

type.defineListeners ->
  if fn = @props.onTap
    tap = @_tap ?= TapResponder()
    tap.didTap fn

#
# Prototype
#

type.definePrototype

  value:
    get: -> @opacity.get()
    set: (value) ->
      @opacity.set value

  progress:
    get: -> (@opacity.get() - @minValue) / (@maxValue - @minValue)
    set: (progress) ->
      @opacity.set @minValue + progress * (@maxValue - @minValue)

type.defineGetters

  animation: -> @opacity.animation

  didResponderGrant: -> @_tap.didGrant.listenable

  didResponderEnd: -> @_tap.didEnd.listenable

type.defineMethods

  animate: (config) ->

    progress = steal config, "progress"
    if isType progress, Number
      config.toValue = @minValue + progress * (@maxValue - @minValue)

    @opacity.animate config

  stopAnimation: ->
    @opacity.stopAnimation()

#
# Rendering
#

type.defineProps
  onTap: Function

type.render ->
  return View
    style: @styles.container()
    pointerEvents: @_containerEvents
    mixins: [@_tap?.touchHandlers]

type.defineStyles

  container:
    cover: yes
    backgroundColor: -> @color
    opacity: -> @opacity

module.exports = type.build()
