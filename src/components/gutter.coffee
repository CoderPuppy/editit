define (require, exports, module) ->
	Component = require './index'

	require('../../jquery');

	class Gutter extends Component
		constructor: ->
			super

			@comps.lines = []

		_render: (el, comps) ->
			el.html ''

			for line in comps.lines
				el.append line

		line: (line, comp) ->
			return this if line < 0

			@line line - 1

			if comp instanceof Component || typeof(comp.render) == 'function'
				@comps.lines.push comp || @comps.lines[line] || new Component

			this

	module.exports = Gutter