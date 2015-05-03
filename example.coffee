
customLog= require 'custom-log'

# the log key relates to the default log function and is a reserved keyword in the initialization object
# create custom log levels and give their messages a prefix
log= customLog
	log 		: 'LOG: '
	warning	: 'WARNING! '
	error		: 'ERROR! '


log 'You can use log for default logging'

log.warning 'Show a warning'

log.error 'some error'

log.disable()
log 'Default log has been disabled, this will not show..'

log.warning.disable()
log 'Not shown'

log.enable()
log 'that\'s about it..'

# can initialize single instance quick
log= customLog 'LOG: '

log 'Yes!'