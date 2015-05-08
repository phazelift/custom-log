custom-log
==========

A tiny (~2kb) flexible logger, very basic, simple and fast. Will add some features over time.

For browser, node, amd.

custom-log is targeted at the Browser as a tiny helper that makes available any custom log function you can
create yourself, and which can be enabled/disabled individually.

Although there are plenty full-fledged loggers for use in node, you can use this one instead if you don't
need a zillion features, but rather prefer simplicity.
___

How to use?
---

> `<function> customLog( <string>/<object> init )`

Returns a log function based on the init argument. The init argument can be either a string or an object.
If init is a string, only the base log function's prefix can be set with a string. In case init is an
object, multiple custom log functions with their own prefix strings can be defined in the init object.
To set the base log function prefix in a init object, use the reserved 'log' key. See some examples below:

```javascript

// customLog is global when load in browser
// but in node:
var customLog= require( 'custom-log' );


// create a single log function with prefix:
var log= customLog( 'LOG: ' );

log( 'hey!' );
// LOG: hey!

// or create a log function with multiple custom log functions attached to it:
var log= customLog({
	// when omitting log, no prefix for the default log function will be used
	log			: 'LOG: ',
	info		: 'INFO: ',
	warning		: 'WARNING: ',
	error		: 'ERROR: ',
	listener	: 'LISTENER: ',
	dal			: 'DAL: '
	// whateverNameYouMayNeed: 'whatever prefix message.. '
});

log( 'hello' );
// LOG: hello

log.info( 'easy!' );
// INFO: easy!

log.dal( 'Success! Payload: ', 'some payload' );
// DAL: Success! Payload: some payload

// now turn of dal messages:
log.dal.disable();

// or turn them on again:
log.dal.enable();

// disable or enable multiple levels at once
// argument can be either (space seperated)String, Array of strings, multiple String arguments
log.disable( 'dal listener error log' );
log.enable( 'error', 'listener', 'log' );

// use build-in assert:
log.assert( 2 > 1 );
// LOG:
//	 Assert: TRUE

log.assert( 2 > 1, '2 > 1' );
// or
log.assert( '2 > 1' );
// LOG:
//	 Assert: (2 > 1) == TRUE

```
___


change log
==========

0.1.0

Initial commit.

___