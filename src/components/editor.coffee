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

		_update: (el, comps) ->
			el.append comps.gutter.el
			el.append comps.layers.el
			el.append new Date().toString()

	module.exports = Editor