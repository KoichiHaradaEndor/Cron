<!-- () -> Object -->
## Description

This method is used to import class store of the Cron component.

When using Cron component, first you will need to import it and then, you can use Cron and also Daemon object.

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

// then start daemon process(es)
$cron_o.start()

// when you want to stop daemon process(es)
$cron_o.stop()
```
