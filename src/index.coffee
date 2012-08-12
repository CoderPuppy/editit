define (require, exports, module) ->
	Editor = require './components/editor'

	exports.edit = (el) ->
		new Editor(el)

	exports