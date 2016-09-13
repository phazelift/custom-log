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


# taken from types.js
intoArray= ( args ) ->
	if args.length < 2
		if typeof args[ 0 ] is 'string'
			args= args.join( '' ).replace( /^\s+|\s+$/g, '' ).replace( /\s+/g, ' ' ).split ' '
		else if (typeof args[ 0 ] is 'object') and (args[ 0 ] instanceof Array)
			args= args[ 0 ]
	return args



customLog= ( init ) ->

	CUSTOM_LOG= 'custom-log: '


	class Log

		constructor: ( @level= 'log', @message= '' ) ->
			@enabled= true

			@log= =>
				if @enabled
					console.log.apply console, [ @message ].concat arguments...

			for prop, value of @
				if ( @.hasOwnProperty prop ) and ( prop isnt 'log' )
					@log[ prop ]= value


		disable: =>
			@enabled= false
			console.log CUSTOM_LOG+ '.'+ @level+ ' is disabled'


		enable: =>
			@enabled= true
			console.log CUSTOM_LOG+ '.'+ @level+ ' is enabled'


		assert: ( predicate, description= '' ) =>
		  if typeof predicate is 'string'
		    description= predicate
		  if description
			  description= '('+ description+ ') == '

		  if typeof predicate is 'string'
		    predicate= eval predicate

		  if predicate then predicate= 'TRUE' else predicate= 'FALSE'

		  @log '\n\t'+ customLog.assertMessage+ description+ predicate+ '\n'


# end of Log


	prefixMsg		= init if typeof init is 'string'
	logInstance	= new Log 'log', prefixMsg
	log 				= logInstance.log

	# one function for enable and disable
	enact= ( method, levels... ) ->
		levels= intoArray levels
		for level in levels
			if level is 'log'
				logInstance[ method ]()
			else if log[ level ]?
				log[ level ][ method ]()

	log.enable	= -> enact 'enable', arguments...
	log.disable	= -> enact 'disable', arguments...


	if typeof init is 'object'
		for level, message of init then do (level, message) ->

			switch level
				when 'log'		then logInstance.message= message
				when 'assert' then customLog.assertMessage= message
				else log[ level ]= new Log( level, message ).log

	return log

customLog.assertMessage= 'Assert: '

# end of customLog


if define? and ( 'function' is typeof define ) and define.amd
	define 'customLog', [], -> customLog

else if typeof module isnt 'undefined'
	module.exports= customLog

else if typeof window isnt 'undefined'
	window.customLog= customLog