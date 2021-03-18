//%attributes = {}
var $cs_o; $cron_o; $daemon1_o; $daemon2_o : Object
var $winRef_l : Integer

ds:C1482.Log.all().drop()

$daemon1_o:=New object:C1471
$daemon1_o.name:="daemontest1d"
$daemon1_o.method:="daemonTest"
$daemon1_o.interval:=2
$daemon1_o.parameter:=New object:C1471("start"; 0)

$daemon2_o:=New object:C1471
$daemon2_o.name:="daemontest2d"
$daemon2_o.method:="daemonTest"
$daemon2_o.interval:=5
$daemon2_o.parameter:=New object:C1471("start"; 100)

$cs_o:=Import Cron
$cron_o:=$cs_o.Cron.new()
$cron_o.add($daemon1_o).add($daemon2_o).setInterval(1).start()

TRACE:C157

//$cron_o.stop()

//TRACE

$daemon1_o:=New object:C1471
$daemon1_o.name:="daemontest1d"
$daemon1_o.method:="daemonTest"
$daemon1_o.interval:=1  // <=== change interval
$daemon1_o.parameter:=New object:C1471("start"; 1000)  // <=== change start

$cron_o.add($daemon1_o).delete("daemontest2d").start()

TRACE:C157

$cron_o.stop()


$winRef_l:=Open form window:C675([Log:1]; "List")
DIALOG:C40([Log:1]; "List")
CLOSE WINDOW:C154($winRef_l)

