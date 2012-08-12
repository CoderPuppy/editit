define (require, exports, module) ->
	editorEl  = document.getElementById 'editor'
	editIt    = require '../lib/index'
	editor    = editIt.edit editorEl
	Component = require '../lib/components/index'

	linenum = new Component('linenum')
	linenum.tag = 'span'
	linenum._update = (el, comps) ->
		el.text '1'

	editor.comps.gutter.line 0, linenum

	{ editorEl, editor, linenum }