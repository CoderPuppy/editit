define (require, exports, module) ->
	Component = require './index'

	require '../../jquery'

	class Gutter extends Component
		_update: (el, comps) ->
			for line in comps.lines
				el.append line.el

		_comps: (comps) ->
			comps.lines = []

		line: (line, comp) ->
			return this if line < 0

			@line line - 1

			if comp instanceof Component || typeof(comp.render) == 'function'
				@comps.lines.push @_registerComp(comp || @comps.lines[line] || new Component)

			this

	module.exports = Gutter