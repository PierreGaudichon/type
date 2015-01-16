{isFunction, isEqual} = require "lodash"

module.exports.tio = (t, f) ->
	(n, {i, o}) ->
		name = ""
		fi = f i
		ok = isEqual fi, o, (a, b) ->
			if isFunction(a) and isFunction(b) then true else undefined
		console.log "#{if ok then "(ok)"else "(!)"} #{t}::#{n}"
		unless ok
			console.log "	calculated : #{JSON.stringify fi}"
			console.log "	expected   : #{JSON.stringify o}"
