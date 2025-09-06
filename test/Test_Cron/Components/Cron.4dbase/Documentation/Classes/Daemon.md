<!-- The "Daemon" class is used to store daemon prosess information -->
# Daemon class

## Description

The `Daemon` is used to store daemon prosess information, especially 
* its name that is also used for worker process name, 
* function that is executed in the dedicated worker repeatedly, 
* interval that defines when the daemon should be executed, 
* and parameter object which is passed to the function when it is executed each time.

The function will be executed in the named worker process repeatedly using the specified interval. So the function need not contain loop structure.

## Constructor

**Daemon.new** (name : Text; function : 4D.Function; interval : Variant; {parameter : Object}) -> `Daemon`

|Name|Type||Description||
|-----|-----|-----|-----|-----|
|name|Text|&#x2192;|The name of the daemon process, used to identify among all the other daemons and as worker name||
|function|4D.Function|&#x2192;|Function object that will be executed in daemon worker||
|interval|Text or Integer|&#x2192;|Interval between the next daemon worker is called||
|parameter|Object|&#x2192;|Parameter to be passed to the function|optional|
|return|cs.Cron.Daemon|&#x2190;|`Daemon` object||

This function instantiate and returns the `Daemon` object.

The `name` parameter is used as the name for the corresponding worker name. So avoid using the same name with other worker names. 

If the `Daemon` object which has the same name has alredy been registered, it will be overwritten with the new one when added to the daemon list. You may want to add "d" character at the end of the name to indicate it is daemon worker process.

`function` is a user function generated via 4D's `Formula` command. It is the function that is called repeatedly as daemon.

The function must be "thread-safe" (it can be set to "indifferent") since the component methods are tagged "thread-safe".

The `interval` parameter defines the interval time between a daemon is executed.

It can take the following formats:

|Format|Type|Description|
|-----|-----|-----|
|Numeric value|Integer|Interval expressed in second<br>ex.: `60` (indicates every 1 minute)|
|"at hh:mm"|Text|The daemon is executed at hh:mm everyday (24-hour notation, 00:00 - 23:59)<br>ex.: `at 01:00`|
|"on the nnth day at hh:mm"|Text|The daemon is executed on the day at the time every month, where "nn" can be the day of the month (numeric) or "last" that indicates the last day of the month<br>ex.: `on the 1st day at 01:00` or `on the last day at 01:00`|
|"every nn {hour(s) / hr(s) / minute(s) / min(s) / second(s) / sec(s)}"|Text|The daemon is executed after given interval<br>ex.: `every 10 seconds`, `every 1 minute` or `every 1 hour`|
|"every weekname at hh:mm"|Text|The daemon is executed at given week name and time<br>ex.: `every Sunday at 08:00`, `every Mon at 23:00`|

Note that when using "on the nnth day at hh:mm" format, since last day numbers of months vary, use "last" keyword when "nn" should indicate 29th day and after.

The optional `parameter` parameter will be passed to the function when it is called each time.

**Note**:

You can access to the `Daemon` object itself inside the function when it runs by using `This` keyword. `This.name` will return the daemon name, `This.interval` will return interval value and `This.next` will return the date and time that indicates when the daemon function will run for the next time (all of them are read-only).

**Note**:

Since daemon management process is run in `thread-safe` mode, the daemon function must be `thread-safe`, too. When you want to run thread-unsafe method, such as updating UI, you may need to use `CALL FORM` or `CALL WORKER` method, by passing text method name to `formula` parameter, not `4D.Formula`.

---

## Functions and Attributes

**Daemon.name** -> `Text`

|Name|Type||Description||
|-----|-----|-----|-----|-----|
|return|Text|&#x2190;|Name attribute value of the Daemon, set in the constructor||

The `name` attribute is set when the `Daemon` object is created using `new()`. It is used as name of the worker where the daemon formula is executed.

This is read-only attribute.

**Daemon.interval** -> `Variant`

|Name|Type||Description||
|-----|-----|-----|-----|-----|
|return|Text or Integer|&#x2190;|Interval attribute value of the Daemon, set in the constructor||

The `interval` attribute is set when the `Daemon` object is created using `new()`. It is used to calculate next launch time.

This is read-only attribute.

**Daemon.next** -> `Text`

|Name|Type||Description||
|-----|-----|-----|-----|-----|
|return|Text|&#x2190;|Next launch time||

The `next` attribute indicates the date and time that shows when the daemon formula shoule be executed. It is calculated based on the `Daemon.interval` value.

This is read-only attribute.
