<!-- The "Daemon" class is used to store daemon prosess information -->
# Daemon class

## Description

The `Daemon` is used to store daemon prosess information, especially 
* its name that is also used for worker process name, 
* function that is executed in the dedicated worker repeatedly, 
* interval that defines when the daemon should be executed, 
* and parameter object which is passed to the function when it is executed each time.

A daemon executed in a dedicated worker process repeatedly.

The function, worker name and interval are specified when Cron.add() function is called.

The function will be executed in the named worker process repeatedly using the specified interval. So the function need not contain loop structure.

## Constructor

**Daemon.new** () -> `Daemon`

|Name|Type||Description||
|-----|-----|-----|-----|-----|
|name|Text|&#x2192;|The name of the daemon process, used to identify among all the other daemons and as worker name||
|function|4D.Function|&#x2192;|Function object that will be executed in daemon worker||
|interval|Text or Integer|&#x2192;|Interval between the next daemon worker is called||
|parameter|Object|&#x2192;|Parameter to be passed to the function|optional|
|return|Object|&#x2190;|`Daemon` object||

This function instantiate and returns the `Daemon` object.

The `name` parameter is used as the name for the corresponding worker name. So avoid using the same name with other worker names. 

If the `Daemon` object which has the same name has alredy been registered, it will be overwritten with the new one when added to the daemon list. You may want to add "d" character at the end of the name to indicate it is daemon worker process.

`function` is a user function generated via 4D's `Formula` command. It is the function that is called repeatedly as daemon.

The `interval` parameter defines the interval time between a daemon is executed.

It can take the following formats:

|Format|Type|Description|
|-----|-----|-----|
|Numeric value|Integer|Interval expressed in second|
|"at hh:mm"|Text|The daemon is executed at hh:mm everyday (24-hour notation, 00:00 - 23:59)|
|"on the nnth day at hh:mm"|Text|The daemon is executed on the day at the time every month, where "nn" can be the day of the month (numeric) or "last" that indicates the last day of the month|
|"every nn {hour(s) / hr(s) / minute(s) / min(s) / second(s) / sec(s)}"|Text|The daemon is executed after given interval|

Note that when using "on the nnth day at hh:mm" format, day numbers of the end of months are not taken into account. So please use "last" keyword when "nn" should indicate 29th day and after.

The optional `parameter` parameter will be passed to the function when it is called each time.

---
