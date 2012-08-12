define (require, exports, module) ->
	Editor = require './components/editor'

	exports.edit = (el) ->
		editor = new Editor(el)
		editor.update()
		editor

	exports