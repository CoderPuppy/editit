define (require, exports, module) ->
	{EventEmitter} = require '../utils/events'

	require '../../jquery'

	MutationObserver = window.MutationObserver || window.WebKitMutationObserver

	class Component extends EventEmitter
		constructor: (name, el) ->
			@name = @constructor.name
			@_registeredComps = []
			@_mutationObserver = new MutationObserver (mutations) =>
				@emit 'changed'
			@_mutationObserver.options = 
				attributes: true
				childList: true
				characterData: true
				subtree: true
			
			if name instanceof HTMLElement || name instanceof $ || typeof(el) == 'string'
				name = [el, el = name][0]

			if el instanceof HTMLElement || el instanceof $
				@el = el

			if typeof(name) == 'string'
				@name = name

			@comps = []
			@_comps @comps
			@_registerComps

		update: ->
			if !(@el instanceof HTMLElement || @el instanceof $)
				console.warn 'No element to render to for %s, creating %s', @name, @tag
				@el = $(document.createElement @tag)

			@el = $(@el) unless @el instanceof $

			@el.addClass 'editit-comp'
			@el.attr 'data-comp', @name.replace(/([a-z])([A-Z])/g, '$1-$2').replace(/_/g, '-').toLowerCase()
			@el.html ''

			unless @el.data('-editit-comp-events')
				for el in @el
					@_mutationObserver.observe(el, @_mutationObserver.options)

				@el.data '-editit-comp-events', true

			Component._updateComps @comps

			@_update @el, @comps

			@emit 'update'

			@el

		@_updateComps: (comps) ->
			subEls = []

			doIt = (key, s) =>
				if s instanceof Component || typeof(s.update) == 'function'
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
				comp.on 'update', => @emit 'changed'
				comp.on 'changed', => @emit 'changed'

				setTimeout (=>
					@update()
					@emit 'comp:sub:add', comp
				), 0

			comp

		_registerComps: (comps = @comps) ->
			@_registerComp comp for comp of comps when comp instanceof Component || typeof(comp.update) == 'function'

		_update: (el, comps) ->
		_comps: (comps) ->
		tag: 'div'

	module.exports = Component