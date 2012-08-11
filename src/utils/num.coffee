define (require, exports, module) ->
	exports.to = to = (s) -> parseInt((s + '').replace(/\D/g, '')) || 0

	exports