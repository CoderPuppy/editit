define(function(require, exports, module) {
	require('./extend');

	Object.defineProperty(Function.prototype, 'extends', {
		value: function(other) {
			this.extend(other);

			this.$super = other;
			this.prototype = Object.create(other.prototype, {
				$super: {
					value: other.prototype
				},
				constructor: {
					value: this
				}
			});
		}
	});
});