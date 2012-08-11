define (require, exports, module) ->
	Component = require './index'
	Gutter    = require './gutter'
	Layers    = require './layers'
	Time      = require './time'
	utils     =
		el: require '../utils/el'

	require '../../jquery'

	class Editor extends Component
		constructor: ->
			self = this

			super

			(->
				@gutter = new Gutter
				@layers = new Layers
				@time   = new Time
			).call @comps

		_render: (el, comps) ->
			el.html ''

			resize = (el) ->
				comps.layers.css 'left', utils.el.measure(el).width + 'px'

			@comps.gutter.on 'rendered', resize
			@once 'render', ->
				@comps.gutter.off 'rendered', resize

			el.append comps.gutter
			el.append comps.layers
			# el.append comps.time
			el.append new Date().toString()

			resize comps.gutter

	module.exports = Editor