# custom-log.coffee - A tiny console.log wrapper, written in Coffeescript.
#
# MIT License
#
# Copyright (c) 2015 Dennis Raymondo van der Sluis
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

"use strict"


CUSTOM_LOG = 'custom-log: '


# taken from types.js
intoArray = ( args ) ->
	if args.length < 2
		if typeof args[ 0 ] is 'string'
			args= args.join( '' ).replace( /^\s+|\s+$/g, '' ).replace( /\s+/g, ' ' ).split ' '
		else if (typeof args[ 0 ] is 'object') and (args[ 0 ] instanceof Array)
			args= args[ 0 ]
	return args


instanceOf	= ( type, value ) -> value instanceof type

forceObject = ( value ) ->
	return if (typeof value is 'object') and (value isnt null) and not instanceOf(Boolean, value) and not instanceOf(Number, value) and not instanceOf(Array, value) and not instanceOf(RegExp, value) and not instanceOf(Date, value)
		value
	else {}
#
#



#
# prefixes is primarily for creating log.anyPrefix methods
#
customLog= ( prefixes, settings ) ->

	# prefixes as string is for a only single log function with prefix
	prefixMsg		= prefixes if typeof prefixes is 'string'
	prefixes			= forceObject prefixes
	settings			= forceObject settings



	class Log

		constructor: ( level, prefix ) ->
			@enabled			= true
			@level			= level or 'log'
			@prefix			= prefix or ''

			@log = (args...) =>
				if @enabled
					prefix = if (typeof @prefix is 'function') then (@prefix args...) else @prefix
					message = if @prefix then ([ prefix ].concat args...) else args
					console.log.apply console, message

			for own prop, value of @
				if (prop isnt 'log') then @log[ prop ]= value



		disable: =>
			@enabled= false
			if not settings.silentDisable
				console.log CUSTOM_LOG+ '.'+ @level+ ' is disabled'


		enable: =>
			@enabled= true
			if not settings.silentEnable
				console.log CUSTOM_LOG+ '.'+ @level+ ' is enabled'

	#
	# end of Log
	#




	# create a default log right away
	logInstance		= new Log 'log', prefixMsg
	log 				= logInstance.log



	# abstract function for enable and disable
	enact= ( method, levels... ) ->
		levels= intoArray levels
		for level in levels
			if level is 'log'
				logInstance[ method ]()
			else if log[ level ]?
				log[ level ][ method ]()

	log.enable	= (args...) -> enact 'enable', args...
	log.disable	= (args...) -> enact 'disable', args...



	# create log levels/instances from prefixes object
	for level, prefix of prefixes then do (level, prefix) ->
		switch level
			# allow the default log to have a prefix
			when 'log' then logInstance.prefix= prefix
			else log[ level ]= new Log( level, prefix ).log



	return log
#
# end of customLog
#




if define? and ( 'function' is typeof define ) and define.amd
	define 'customLog', [], -> customLog

else if typeof module isnt 'undefined'
	module.exports= customLog

else if typeof window isnt 'undefined'
	window.customLog= customLog
