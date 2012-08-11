define (require, exports, module) ->
	Component = require './index'

	require '../../jquery'

	class Time extends Component
		constructor: ->
			super

			@tag = 'span'
			@force = true

		_render: (el, comps) ->
			el.text new Date().toString()

	module.exports = Time