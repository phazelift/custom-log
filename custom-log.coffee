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


customLog= ( init ) ->

	class Log

		constructor: ( @level= 'log', @message= '' ) ->
			@enabled= true

			@log= =>
				if @enabled
					console.log @message.concat arguments...

			for name, prop of @
				if ( @.hasOwnProperty name ) and ( name isnt 'log' )
					@log[ name ]= prop


		disable: =>
			@enabled= false
			console.log 'CUSTOM-LOG: '+ @level+ ' has been disabled.'

		enable: =>
			@enabled= true
			console.log 'CUSTOM-LOG: '+ @level+ ' is now enabled.'



	stringArg	= init if typeof init is 'string'
	log 			= new Log( 'log', stringArg ).log

	if typeof init is 'object'
		for level, message of init then do (level, message) ->
			if level is 'log'
				log.message= message
			else
				log[ level ]= new Log( level, message ).log

	return log




if define? and ( 'function' is typeof define ) and define.amd
	define 'customLog', [], -> customLog

else if typeof module isnt 'undefined'
	module.exports= customLog

else if typeof window isnt 'undefined'
	window.customLog= customLog

