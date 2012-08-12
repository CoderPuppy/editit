define (require, exports, module) ->
	Component = require './index'
	Gutter    = require './gutter'
	Layers    = require './layers'
	Time      = require './time'
	utils     =
		el: require '../utils/el'

	require '../../jquery'

	class Editor extends Component
		_comps: (comps) ->
			comps.gutter = new Gutter
			comps.layers = new Layers

			comps.layers.add (->
				@tag = 'span'
				@_update = (el, comps) ->
					el.text new Date().toString()

				this
				).call(new Component('Time'))

			comps.gutter.on 'changed', ->
				# console.log 'gutter changed'
				# console.trace()
				comps.layers.el.css('left', utils.el.width(@el))

		_update: (el, comps) ->
			el.append comps.gutter.el
			el.append comps.layers.el

	module.exports = Editor