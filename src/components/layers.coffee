define (require, exports, module) ->
	Component = require './index'

	require '../../jquery'

	class Layers extends Component
		_comps: (comps) ->
			comps.layers = @layers = []

		_update: (el, comps) ->
			comps.layers.forEach (layer) ->
				el.append layer.el

		add: (comp) ->
			if comp instanceof Component || typeof(comp.update) == 'function'
				@layers.push @_registerComp(comp)

			this

	module.exports = Layers