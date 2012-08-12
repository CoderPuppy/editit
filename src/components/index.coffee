define (require, exports, module) ->
	{EventEmitter} = require '../utils/events'

	require '../../jquery'

	class Component extends EventEmitter
		constructor: (name, el) ->
			@name = @constructor.name
			@_registeredComps = []
			
			if name instanceof HTMLElement || name instanceof $ || typeof(el) == 'string'
				name = [el, el = name][0]

			if el instanceof HTMLElement || el instanceof $
				@el = el

			if typeof(name) == 'string'
				@name = name

			@on 'comp:sub:add', (comp) ->
				@update()

			@comps = []
			@_comps @comps
			@update()

		update: ->
			if !(@el instanceof HTMLElement || @el instanceof $)
				console.warn 'No element to render to for %s, creating %s', @name, @tag
				@el = $(document.createElement @tag)

			@el = $(@el) unless @el instanceof $

			@el.addClass 'editit-comp'
			@el.attr 'data-comp', @name.replace(/([a-z])([A-Z])/g, '$1$2').replace(/_/g, '-').toLowerCase()
			@el.html ''

			Component._updateComps @comps

			@_update @el, @comps

			@emit 'update'

			@el

		@_updateComps: (comps) ->
			subEls = []

			doIt = (key, s) =>
				if s instanceof Component || typeof(s.render) == 'function'
					subEls[key] = s.update()
				else if typeof(s.length) == 'number' || typeof(s) == 'object' || typeof(s) == 'string'
					subEls[key] = @_updateComps s

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
						if name == 'length' || /^[0-9]+$/.test(name) || name == 'each' || name == 'forEach'
							false
						else
							true

				names.map((name) ->
					[name, comps[name]]
				).forEach((a) ->
					doIt a[0], a[1]
				)

			subEls

		_registerComp: (comp) ->
			unless ~@_registeredComps.indexOf(comp)
				@_registeredComps.push comp
				comp.on 'update', =>


				setTimeout (=> @emit 'comp:sub:add', comp), 0

			comp

		_update: (el, comps) ->
		_comps: (comps) ->
		tag: 'div'

	module.exports = Component