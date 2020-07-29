custom-log
==========

A tiny (~2kb) flexible logger, very basic, simple and fast. Will add some features over time.

custom-log is targeted at the Browser as a tiny helper that makes available any custom log function you can create yourself, and which can be enabled/disabled individually.

Although there are plenty full-fledged loggers for use in node, you can use this one instead if you don't need a zillion features but rather prefer simplicity.
___

How to use?
---

First install:
>Browser: `<script src="./custom-log.min.js"></script>`

>Node: `npm install --save custom-log`

<br/>

> `<function> customLog( <string>/<object> init )`

Returns a log function based on the init argument. The init argument can be either a string or an object.
If init is a string, only the base log function's prefix can be set with a string. In case init is an
object, multiple custom log functions with their own prefix strings can be defined in the init object.
To set the base log function prefix in a init object, use the reserved 'log' key. See some examples below:

```javascript

// customLog is global when loaded in browser, for node use:
const customLog= require( 'custom-log' );


// create a single log function without prefix:
const log= customLog();

log( 'hey!' );
// hey!


// create a log function with multiple custom log functions attached to it
// you can silently enable/disable by adding settings if needed:
const settings = {
	silentDisable	: false	// default
	silentEnable	: false	// default
};

const log= customLog({
	info		: 'INFO: ',
	warning		: 'WARNING: ',
	error		: 'ERROR: ',
	listener	: 'LISTENER: ',
	dal			: 'DAL: '
	// use the result of a function as prefix for logs
	time		: () => new Date()
}, settings );

log( 'hello' );
// hello

log.info( 'easy!' );
// INFO: easy!

log.dal( 'Success! Payload: ', 'some payload' );
// DAL: Success! Payload: some payload

// now temporarily turn off dal messages:
log.dal.disable();

// and turn them on again:
log.dal.enable();

// disable or enable multiple levels at once
// arguments can be either (space seperated)String, Array of strings, multiple Strings
log.disable( 'dal listener error log' );
// or
log.enable( 'error', 'listener', 'log' );
// or
log.enable( ['error', 'listener', 'log'] );
```
___


change log
==========

0.3.0

-	removes log.assert
-	adds dynamic function prefix
-	adds 'silentEnable' and 'silentDisable' initialization modes

---

0.2.3

-	removes leading space for default log without prefix
-	log.assert is way too naive and you better use something like the 'assert' npm lib for that. log.assert is now deprecated and will be removed over time.

---

0.2.1

changes license to MIT
___

0.1.9

Fixed bug that caused a crash on using the disable or enable function

___

0.1.6

Added log.assert function

___

0.1.0

Initial commit.

___

###license

MIT
