
{ NativeValue, Touchable, View } = require "component"
{ Void } = require "type-utils"

module.exports = Factory "Darkness",

  optionTypes:
    opacity: Number
    range: Array
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
        assertType value, Number
        @_opacity.value = value

    progress:
      get: ->
        @_opacity.getProgress { from: @minOpacity, to: @maxOpacity }
      set: (progress) ->
        assertType progress, Number
        @_opacity.setProgress { progress, from: @minOpacity, to: @maxOpacity }

    onPress:
      value: null
      reactive: yes
      didSet: ->

    _component: lazy: ->
      require "./DarknessView"

  initValues: (options) ->

    onPress: options.onPress

  initFrozenValues: (options) ->

    range: options.range

    _opacity: NativeValue options.opacity

  init: ->
    @_opacity.value ?= @minOpacity

  render: ->
    return @_component
      darkness: this
