define (require, exports, module) ->
	{EventEmitter} = require '../utils/events'

	require '../../jquery'

	class Component extends EventEmitter
		constructor: (name = @constructor.name, el) ->
			@name = @constructor.name
			
			if name instanceof HTMLElement || name instanceof $
				name = [el, el = name][0]

			if el instanceof HTMLElement || el instanceof $
				@el = el
			else if typeof(name) == 'string'
				@name = name

			@tag = 'div'
			@force = false
			@comps = []
			@_needsRender = true

		autorender: (time) ->
			clearTimeout @_autorenderId

			if time > 0
				render = =>
					@render()

					@_autorenderId = setTimeout render, time

				render()

			this

		render: (el, force) ->
			if typeof(el) == 'boolean'
				el = [force, force = el]

			el = if el instanceof HTMLElement || el instanceof $ then el else @el

			if !(el instanceof HTMLElement || el instanceof $)
				console.warn 'No element to render to for %s, creating %s', @name, @tag
				el = $(document.createElement @tag)

			el = $(el)

			if !(@el instanceof HTMLElement || @el instanceof $)
				@el = el

			el.addClass 'editit-comp'
			el.attr 'data-comp', @name.replace(/([a-z])([A-Z])/g, '$1$2').replace(/_/g, '-').toLowerCase()

			@emit 'rendering'

			comps = Component._renderComps @comps

			if force || @force || @_needsRender
				@emit 'render'
				@_render el, comps
				@emit 'rendered', el

				@_needsRender = false

			el

		@_renderComps: (comps) ->
			subEls = []

			doIt = (key, s) =>
				if s instanceof Component || typeof(s.render) == 'function'
					subEls[key] = s.render()
				else if typeof(s.length) == 'number' || typeof(s) == 'object' || typeof(s) == 'string'
					subEls[key] = @_renderComps s

			if typeof(comps) == 'object' || typeof(comps) == 'string'
				names = Object.getOwnPropertyNames comps

				if typeof(comps.length) == 'number' || typeof(comps.each) == 'function' || typeof(comps.forEach) == 'function'
					if typeof(comps.each) == 'function' || typeof(comps.forEach) == 'function'
						(if typeof(comps.each) == 'function' then comps.each else comps.forEach).call comps, (s, key) ->
							doIt key, s
					else
						for comp, i in comps
							doIt i, comp

					names = names.filter (name) ->
						if name == 'length' || /^[0-9]$/.test(name) || name == 'each' || name == 'forEach'
							false
						else
							true

				names.map((name) ->
					[name, comps[name]]
				).forEach((a) ->
					doIt a[0], a[1]
				)

			subEls

		_render: (el, comps) ->

	module.exports = Component