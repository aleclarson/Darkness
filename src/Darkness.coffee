
{ NativeValue, Touchable, View } = require "component"
{ Void } = require "type-utils"

emptyFunction = require "emptyFunction"

module.exports = Factory "Darkness",

  optionTypes:
    opacity: Number
    range: Array
    easing: [ Function, Void ]
    within: [ Array, Void ]
    onPress: [ Function, Void ]

  optionDefaults:
    opacity: 0

  customValues:

    minOpacity: get: ->
      @range[0]

    maxOpacity: get: ->
      @range[1]

    opacity:
      get: ->
        @_opacity.value
      set: (value) ->
        @_opacity.value = value

    progress:
      get: ->
        @_opacity.getProgress { from: @minOpacity, to: @maxOpacity }
      set: (progress) ->
        @_opacity.setProgress { progress, from: @minOpacity, to: @maxOpacity }

    easing:
      get: -> @_opacity._easing
      set: (easing) ->
        @_opacity._easing = easing

    within:
      get: -> @_opacity._inputRange
      set: (inputRange) ->
        @_opacity._inputRange = inputRange

    _component: lazy: ->
      require "./DarknessView"

  initReactiveValues: (options) ->

    onPress: options.onPress

  initFrozenValues: (options) ->

    range: options.range

    _opacity: NativeValue options.opacity

  init: (options) ->
    @_opacity.type = Number
    @_opacity.value ?= @minOpacity
    @easing = options.easing
    @within = options.within

  animate: (options) ->
    @_opacity.animate options

  render: ->
    return @_component
      darkness: this
