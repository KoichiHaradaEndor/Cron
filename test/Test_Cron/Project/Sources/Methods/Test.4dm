//%attributes = {}
var $cs_o; $cron_o; $daemon1_o; $daemon2_o : Object
var $winRef_l : Integer

ds:C1482.Log.all().drop()

// Import Cron is the only method shared with host application
$cs_o:=Import Cron

// Creates Daemon objects
$daemon1_o:=$cs_o.Daemon.new("daemontest1d"; Formula:C1597(daemonTest); 2; New object:C1471("start"; 0))
$daemon2_o:=$cs_o.Daemon.new("daemontest2d"; Formula:C1597(daemonTest); 5; New object:C1471("start"; 100))

// Creates Cron objects and configure it
$cron_o:=$cs_o.Cron.new()
$cron_o.add($daemon1_o).add($daemon2_o).setInterval(1).start()

TRACE:C157

// Modifies interval and parameter of the "daemontest1d" daemon
$daemon1_o:=$cs_o.Daemon.new("daemontest1d"; Formula:C1597(daemonTest); 1; New object:C1471("start"; 1000))

// then overwrtite existing one and remove "daemontest2d"
$cron_o.add($daemon1_o).delete("daemontest2d")

TRACE:C157

$cron_o.stop()


$winRef_l:=Open form window:C675([Log:1]; "List")
DIALOG:C40([Log:1]; "List")
CLOSE WINDOW:C154($winRef_l)

