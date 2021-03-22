<!-- The "Cron" class is used to manage user daemon processes -->
# Cron class

## Description

The `Cron` class is used to manage user daemon processes.

Once `Daemon`s are registered under the daemon management process, the process repeatedly checks each daemon if it should be called or not (calculated via inerval attribute value of the daemon). If it is true, then the daemon function is executed.

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
|return|Object|&#x2190;|`Cron` object||

Register a given daemon under cron's management.

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
|return|Object|&#x2190;|`Cron` object||

This function is used to set the Cron manager execution interval, in second.

It defines how long the daemon management process should delay to the next checking loop.

The default interval value is 60 seconds.

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
