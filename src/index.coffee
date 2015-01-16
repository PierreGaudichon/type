{isPlainObject, isFunction, isArray, map, clone} = require "lodash"



# Namespace.
module.exports = t = {}



# t.args
#
# This function takes a pseudo array and return a real array. It
# has all the array methods.
#
# (PseudoArray) -> Array
t.args = (a) -> Array.prototype.slice.call a



# t.type
#
# Takes a function and return a function (constructor).
# Basically it currify.
#
# Exemple :
# 	Human = type.type (name) ->
# 		pseudo: name
# 		level: 0
# 		up: -> @level++
#
# ((a, b, ...) -> Hash) -> Function
t.type = (fun) ->
	ret = () ->
		fun.apply null, arguments
	# This is ugly. But the best solution, I think.
	# See : http://stackoverflow.com/questions/7316688/
	# how-to-programmatically-set-the-length-of-a-function
	ret.nbArguments = fun.length
	return ret



# t.extend
#
# (Function, (a, b, ...) -> Hash) -> Function
t.extend = (type, fun) ->
	return () ->
		args = t.args arguments
		baseArgs = args.slice 0, args.length - type.nbArguments
		extArgs = args.slice type.nbArguments

		base = type.apply null, baseArgs
		ext = fun.apply null, extArgs

		for k, v of base
			ext[k] = v unless ext[k]?
		return ext


# t.iterator
#
# This function returns an object contening all the avaiables
# methods in the arguments.
# When a method is called, it returns an array contening all
# return values from the methods we just iterate over.
#
#  (Hash ...) -> Hash

###
# First implementation, work for function but skip properties.
t.iterator = () ->
	args = t.args arguments
	ret = {}

	# We parcours all the functions arguments
	for a in args
		# For each of thoses arguments we parcours it's internal
		# propeties.
		for k, v of a
			# And then, when the propertie is a function and is unset
			# in the returned object,
			if (not ret[k]?) and isFunction v
				# we assign a function to that value in the
				# returned object. The wrapper (do ->) is there
				# to keep track of the property name.
				ret[k] = do(k) -> () ->
					# At each call of the iterator method, we parcours
					# the arguments again. And when the method exists,
					for a in args when a[k]?
						# we call it.
						a[k].apply a, arguments

			else if (not ret[k]?) and (not isFunction v)
				ret[k] = [v]
			else if (not isFunction v)
				ret[k].push v

	#console.log ret
	#for k, v of ret
		#ret[k] = t.iterator.apply null, v if isArray v


	# Finnaly we return the iterator object.
	# If everything is ok, that object contains all methods
	# callables in the objects we passed to the t.iterator
	# function.
	return ret
###

# Third implementation, works, but properties are functions and
# not iterators.
t.iterator = () ->
	# All the arguments as an array.
	args = t.args arguments
	# All the avaiables in the collection's properties/methods.
	allProperties = []
	# The returned object, contains some methods.
	ret = -> args


	for a in args
		for k, v of a
			allProperties.push k
		protoArr = Object.getOwnPropertyNames a.__proto__
		allProperties = allProperties.concat protoArr


	for prop in allProperties when not ret[prop]?
		ret[prop] = do(prop) -> () ->
			#console.log "HERE"
			r = for a in args when a[prop]?
				if isFunction a[prop]
					a[prop].apply a, arguments
				else
					a[prop]
			return t.iterator.apply null, r
	return ret
