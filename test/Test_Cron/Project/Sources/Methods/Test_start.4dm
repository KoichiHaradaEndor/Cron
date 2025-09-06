//%attributes = {}
var $cron_o : cs:C1710.Cron.Cron
var $daemon60sec_o; $daemon2min_o; $daemon1hour_o; $daemonAt0100_o; $daemonOn3At0100_o : cs:C1710.Cron.Daemon

//ds.Log.all().drop()

// Creates Daemon objects
$daemon60sec_o:=cs:C1710.Cron.Daemon.new("daemon60sec"; Formula:C1597(daemon_method); "every 60 sec"; {message: "every 60 sec"})
$daemon2min_o:=cs:C1710.Cron.Daemon.new("daemon2min"; Formula:C1597(daemon_method); "every 2 min"; {message: "every 2 min"})
$daemon1hour_o:=cs:C1710.Cron.Daemon.new("daemon1hour"; Formula:C1597(daemon_method); "every 1 hour"; {message: "every 1 hour"})
$daemonAt0100_o:=cs:C1710.Cron.Daemon.new("daemonAt0100"; Formula:C1597(daemon_method); "at 01:00"; {message: "at 01:00"})
$daemonOn3At0100_o:=cs:C1710.Cron.Daemon.new("daemonOn2At0100"; Formula:C1597(daemon_method); "on the 2nd day at 01:00"; {message: "on the 2nd day at 01:00"})

// then add them under cron management
$cron_o:=cs:C1710.Cron.Cron.me
$cron_o.add($daemon60sec_o)
$cron_o.add($daemon2min_o)
$cron_o.add($daemon1hour_o)
$cron_o.add($daemonAt0100_o)
$cron_o.add($daemonOn3At0100_o)
$cron_o.setInterval(10)
$cron_o.start()

CALL WORKER:C1389("Test_showList"; Formula:C1597(Test_showList))
