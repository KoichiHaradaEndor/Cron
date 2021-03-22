<!-- () -> Object -->
# Import Cron

## Description

This method is used to import class store of the Cron component.

The class store of the Cron component includes `Cron` and `Daemon` object.

## Example

```4d
var $cs_o; $cron_o; $daemon_o : Object

$cs_o:=Import Cron

// Creates Daemon instance object
$daemon_o:=$cs_o.Daemon.new("DaemonNamed"; Formula(DaemonMethod); 60; New object("parameter"; "value"))

// Creates Cron instance object
$cron_o:=$cs_o.Cron.new()

// Register daemon object under the cron's management
$cron_o.add($daemon_o)

// Set cron management interval to 10 secs.
$cron_o.setInterval(10)

// then start daemon process(es)
$cron_o.start()

// when you want to stop daemon process(es)
$cron_o.stop()
```
