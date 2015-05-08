# custom-log.coffee - A tiny console.log wrapper, written in Coffeescript.
#
# Copyright (c) 2015 Dennis Raymondo van der Sluis
#
# This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <http://www.gnu.org/licenses/>

"use strict"

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

		log= console.log

		constructor: ( @level= 'log', @message= '' ) ->
			@enabled= true

			@log= =>
				if @enabled
					log.apply console, [ @message ].concat arguments...

			for name, prop of @
				if ( @.hasOwnProperty name ) and ( name isnt 'log' )
					@log[ name ]= prop


		disable: =>
			@enabled= false
			log CUSTOM_LOG+ '.'+ @level+ ' has been disabled'

		enable: =>
			@enabled= true
			log CUSTOM_LOG+ '.'+ @level+ ' is now enabled'

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
	enact= ( method, names... ) ->
		names= intoArray names
		for name in names
			if name is 'log'
				logInstance[ method ]()
			else if log[ name ]?
				log[ name ][ method ]()

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