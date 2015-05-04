
# when load in browser:
# var log= customLog;

# in node
customLog= require './custom-log'

# the log key relates to the default log function and is a reserved keyword in the initialization object
# create custom log levels and give their messages a prefix
log= customLog
	log 		: 'LOG: '
	warning	: 'WARNING! '
	error		: 'ERROR! '
	listener: 'LISTENER: '
	# whateverName: 'whatever.. '


log 'You can use log for default logging'
log.warning 'Show a warning'
log.error 'some error'
log.listener 'track some listeners'
# log.whateverName 'Enable in initialization before use..'

log.disable()
log 'Default log has been disabled, this will not show..'

log.warning.disable()
log.warning 'Not shown'

log.enable()
log 'that\'s about it..'

# can initialize single instance quick
log= customLog 'LOG: '
log 'Yes!'