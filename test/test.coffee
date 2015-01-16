{tio} = require "../bin/tio"
{type, extend, iterator} = require "../bin/index"



typeT = tio "type", (i) ->
	type(i.f).apply null, i.a


extendT = tio "extend", (i) ->
	extend(i.type, i.fun).apply null, i.a


iteratorF = tio "iterator#function call", (i) ->
	iterator.apply(null, i.all)[i.meth].apply(null, i.a)()


iteratorP = tio "iterator#property get", (i) ->
	m = Array.prototype[i.meth]
	c = iterator.apply(null, i.all)[i.prop]()
	e = c[i.meth].apply c, i.a
	return e()



Car = type (color) ->
	color: color
	brad: (name) -> "#{name}'s car is #{@color}."

Limo = extend Car, (length) ->
	length: length
	brad: (name) -> "#{name}'s limo measure #{@length}m."




c1 = Car "red"
c2 = Car "yellow"
l1 = Limo "black", 2
l2 = Limo "green", 3
#fleet = iterator c1, c2, l1, l2




typeT "simple",
	i:
		f: (foo) -> {foo}
		a: ["a"]
	o: {foo: "a"}


typeT "more args",
	i:
		f: (a, b, c, d) -> {a, b, c, d}
		a: [0,1,2,3]
	o: {a: 0, b: 1, c: 2, d: 3}


extendT "simple",
	i:
		type: Car
		fun: (length) -> {length}
		a: ["yellow", 4]
	o: {length: 4, color: "yellow", brad: ->}


iteratorF "simple",
	i:
		all: [c1, c2, l1, l2]
		meth: "brad"
		a: ["Jon"]
	o: [
		"Jon's car is red."
		"Jon's car is yellow."
		"Jon's limo measure 2m."
		"Jon's limo measure 3m."
	]


iteratorP "simple",
	i:
		all: [c1, c2, l1, l2]
		prop: "color"
		meth: "slice"
		a: []
	o: ["red", "yellow", "black", "green"]
