//%attributes = {}
//%attributes = {}
var $cron_o : cs:C1710.Cron

$cron_o:=cs:C1710.Cron.me

$cron_o.delete("DaemonNamed60")
$cron_o.delete("DaemonNamedOnDayAtTime")
$cron_o.delete("DaemonNamedEveryHour")
$cron_o.delete("DaemonNamedEveryMin")
$cron_o.delete("DaemonNamedEverySec")

// Creates Daemon instance object, then
// register it object under the cron's management
//$daemon_o:=cs.Daemon.new("DaemonNamed60"; Formula(DaemonMethod60); 60)
//$cron_o.add($daemon_o)
$daemon_o:=cs:C1710.Daemon.new("DaemonNamedOnDayAtTime"; Formula:C1597(DaemonMethodAt0000); "on the last day at 14:32")
$cron_o.add($daemon_o)
//$daemon_o:=cs.Daemon.new("DaemonNamedEveryHour"; Formula(DaemonMethodEveryHour); "every 1 hour")
//$cron_o.add($daemon_o)
$daemon_o:=cs:C1710.Daemon.new("DaemonNamedEveryMin"; Formula:C1597(DaemonMethodEveryMin); "every 1 minutes")
$cron_o.add($daemon_o)
//$daemon_o:=cs.Daemon.new("DaemonNamedEverySec"; Formula(DaemonMethodEverySec); "every 20 seconds")
//$cron_o.add($daemon_o)

// Set cron management interval to 5 secs.
$cron_o.setInterval(5)

// then start daemon process(es)
$cron_o.start()

// when you want to stop daemon process(es)
$cron_o.stop()