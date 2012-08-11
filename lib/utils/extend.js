define(function(require, exports, module) {
	Object.defineProperty(Object.prototype, 'extend', {
		value: function extend() {
			var srcs = [].slice.call(arguments),
			    dest = this;

			switch(typeof(this)) {
				case 'boolean'  :
				case 'undefined':
				case 'number'   :
				case 'string'   :
					return srcs[srcs.length - 1];
				case 'object':
					if(this === null)
						return srcs[srcs.length - 1];

					break;
			}

			srcs.forEach(function(src) {
				switch(typeof(src)) {
					case 'boolean'  :
					case 'undefined':
					case 'number'   :
					case 'string'   :
						return;
					case 'object':
						if(src === null)
							return;
						else

						break;
				}

				// try {
					Object.getOwnPropertyNames(src).forEach(function(name) {
						var oldDescriptor = Object.getOwnPropertyDescriptor(this, name) || {},
							newDescriptor = Object.getOwnPropertyDescriptor(src, name) || {},
						    allowed;

						oldDescriptor.accessor = typeof(oldDescriptor.get) == 'function' || typeof(oldDescriptor.set) == 'function';
						oldDescriptor.valid    = 'value' in oldDescriptor || oldDescriptor.accessor;
						newDescriptor.accessor = typeof(newDescriptor.get) == 'function' || typeof(newDescriptor.set) == 'function';
						newDescriptor.valid    = 'value' in newDescriptor || newDescriptor.accessor;

						allowed = newDescriptor.valid && (!oldDescriptor.valid || (oldDescriptor.valid && oldDescriptor.configurable));

						if(allowed) {
							if(newDescriptor.accessor || oldDescriptor.accessor) {
								
							} else if(oldDescriptor.valid) {
								newDescriptor.value = Object.prototype.extend.call(oldDescriptor.value, newDescriptor.value);
							}

							Object.defineProperty(this, name, newDescriptor);
						}
					}.bind(this));
				// } catch(e) {
				// 	console.log('%s on', e.stack, src, typeof(src));
				// }
			}.bind(this));

			return this;
		}
	});
});