define (require, exports, module) ->
	num = require './num'

	exports.width = width = (el) ->
		el = $(el)

		num.to(el.css 'margin-left'      ) +
		num.to(el.css 'border-left-size' ) +
		# num.to(el.css 'padding-left'     ) +
		num.to(el.css 'width'            ) +
		# num.to(el.css 'padding-right'    ) +
		num.to(el.css 'border-right-size') +
		num.to(el.css 'margin-right'     )

	exports.height = height = (el) ->
		el = $(el)

		num.to(el.css 'margin-top'        ) +
		num.to(el.css 'border-top-size'   ) +
		# num.to(el.css 'padding-top'       ) +
		num.to(el.css 'width'             ) +
		# num.to(el.css 'padding-bottom'    ) +
		num.to(el.css 'border-bottom-size') +
		num.to(el.css 'margin-bottom'     )

	exports.measure = measure = (el) ->
		{ height: height(el), width: width(el) }

	exports