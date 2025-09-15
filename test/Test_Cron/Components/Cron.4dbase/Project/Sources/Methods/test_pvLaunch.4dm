//%attributes = {}
var $cron_o : cs:C1710.Cron

$cron_o:=cs:C1710.Cron.me
$daemon_o:=cs:C1710.Daemon.new("pvd"; Formula:C1597(test_pv); 2)
$cron_o.add($daemon_o)
$cron_o.setInterval(1)
$cron_o.start()

$cron_o.stop()