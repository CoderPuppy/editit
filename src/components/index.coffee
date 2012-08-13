define (require, exports, module) ->
	{EventEmitter} = require '../utils/events'

	require '../../jquery'
	require '../utils/extend'
	MutationSummary = require '../utils/mutation_summary'

	class Component extends EventEmitter
		constructor: (name, el) ->
			@name = @constructor.name
			@_registeredComps = []
			@_mutationSummaryOptions =
				callback: (summaries) =>
					debugger
					summary =
						added: summaries.reduce(( (a, s) -> a.concat(s.added) ), [])
						removed: summaries.reduce(( (a, s) -> a.concat(s.removed) ), [])
						reparented: summaries.reduce(( (a, s) -> a.concat(s.reparented) ), [])
						reordered: summaries.reduce(( (a, s) -> a.concat(s.reordered) ), [])

					nodes = summary.added.concat(summary.reordered).concat(summary.removed).concat(summary.reparented)
					should = nodes.some((node) => ~[].slice.call(@el[0].childNodes).indexOf(node) || ~[].slice.call(@el).indexOf(node))
					# console.log summaries, this, should, nodes.map((n) -> if n.dataset then n.dataset.comp else n.nodeName)

					@emit 'changed' if should
				observeOwnChanges: true
				queries: [
					{ all: true }
				]
			
			if name instanceof HTMLElement || name instanceof $ || typeof(el) == 'string'
				name = [el, el = name][0]

			if el instanceof HTMLElement || el instanceof $
				@el = el

			if typeof(name) == 'string'
				@name = name

			@comps = []
			@changed = true
			@_comps @comps
			@_registerComps()

		update: ->
			if !(@el instanceof HTMLElement || @el instanceof $)
				console.warn 'No element to render to for %s, creating %s', @name, @tag
				@el = $(document.createElement @tag)

			@el = $(@el) unless @el instanceof $

			@el.addClass 'editit-comp'
			@el.attr 'data-comp', @name.replace(/([a-z])([A-Z])/g, '$1-$2').replace(/_/g, '-').toLowerCase()

			unless @el.data('-editit-comp-events') == @name
				@_mutationSummary = new MutationSummary { rootNode: @el[0] }.extend(@_mutationSummaryOptions)

				@el.data '-editit-comp-events', @name

			Component._updateComps @comps

			@el.html ''

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
			console.log "Registering #{comp.name} for #{@name}"
			unless ~@_registeredComps.indexOf(comp)
				@_registeredComps.push comp
				onChange = =>
					@emit 'changed'

				comp.on 'update', onChange
				comp.on 'changed', onChange
				setTimeout (=>
					@update()
					@emit 'comp:sub:add', comp
				), 0

			comp

		_registerComps: (comps = @comps) ->
			@_registerComp comp for comp of comps when comp instanceof Component || typeof(comp.update) == 'function'

			this

		_update: (el, comps) ->
		_comps: (comps) ->
		tag: 'div'

	module.exports = Component