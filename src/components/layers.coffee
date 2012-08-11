define (require, exports, module) ->
	Component = require './index'

	require '../../jquery'

	class Layers extends Component
		constructor: ->
			super

			@comps.layers = @layers = []

		_render: (el, comps) ->
			el.html ''

			comps.layers.forEach (comp) ->
				el.append comp

		add: (comp) ->
			if comp instanceof Component || typeof(comp.render) == 'function'
				@layers.push comp

			this

	module.exports = Layers