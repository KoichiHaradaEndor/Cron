<!-- The "Cron" class is used to manage user daemon processes -->
# Cron class

## Description

The `Cron` class is used to manage user daemon processes.

Once `Daemon` are registered under the daemon management process, the process repeatedly checks each daemon if it should be called (calculated via inerval attribute value of the daemon). If it is true, then the daemon function is executed.

A `Daemon` is executed in a dedicated worker process so process objects such as current selection, current record, process variable are kept.

## Constructor

**Cron.new** () -> `Cron`

|Name|Type||Description||
|-----|-----|-----|-----|-----|
|return|Object|&#x2190;|`Cron` object||

This function instantiate and returns the Cron object.

---

## Function

**Cron.add** (daemon : `Daemon`) -> `Cron`

|Name|Type||Description||
|-----|-----|-----|-----|-----|
|daemon|Object|&#x2192;|`Daemon` object which is instancisted via `Daemon`.new()||
|return|Object|&#x2190;|`Cron` object||

Register a given daemon under cron's management.

You can register multiple numbers of daemons as you want.

---

**Cron.delete** (name : Text) -> `Cron`

|Name|Type||Description||
|-----|-----|-----|-----|-----|
|name|Text|&#x2192;|The name attribute value of the `Daemon` object to delete||
|return|Object|&#x2190;|`Cron` object||

This function is used to remove the specified daemon from Daemons list.

If the daemon that has the same name does not exist, it does nothing.

---

**Cron.setInterval** (interval : Integer) -> `Cron`

|Name|Type||Description||
|-----|-----|-----|-----|-----|
|interval|Integer|&#x2192;|The interval value of the `Cron` object||
|return|Object|&#x2190;|`Cron` object||

This function is used to set the Cron manager execution interval, in second.

It defines how long the daemon management process should delay to the next checking loop.

The default interval value is 60 seconds.

**Note :** 
There are two interval settings which are `Cron`'s interval and `Daemon`'s interval.

`Cron`'s daemon management process checks daemon list to find out daemons to execute. The `Cron`'s interval defines daemon management process execution cycle. The default is 60 seconds that means the process checks the dameon list every minute.

The `Daemon`'s interval defines the interval of the daemon's execution cycle. If it is set to "at 12:00", the daemon method should be executed at noon every day.

In the above case, there can be max 1 minute delay actualy the daemon is executed. Because when the daemon management process checks the list at 11:59:59, the next checking time will be 12:00:59, then the daemon is executed in this checking cycle.

You need to change `Cron`'s interval short enough compared to any `Daemon`'s interval. For instance, when a `Daemon` is created whose interval is "every 5 secs", you will need to set the `Cron`s interval to 1 second. 

---

**Cron.start** () -> `Cron`

|Name|Type||Description||
|-----|-----|-----|-----|-----|
|return|Object|&#x2190;|`Cron` object||

Call this function to start cron manager worker process, so the daemon processes.

---

**Cron.stop** () -> `Cron`

|Name|Type||Description||
|-----|-----|-----|-----|-----|
|return|Object|&#x2190;|`Cron` object||

Call this function to stop cron manager worker process and the daemon processes.

---
