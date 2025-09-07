//%attributes = {}
var $names_c; $deamonsToInstall_c : Collection
var $deamonsToInstall_o : Object
var $name_t : Text
var $cron_o : cs:C1710.Cron.Cron
var $daemon_o : cs:C1710.Cron.Daemon
var $logEntity_o : cs:C1710.LogEntity

//ds.Log.all().drop()

$cron_o:=cs:C1710.Cron.Cron.me

// Remove currently installed daemons
$names_c:=$cron_o.getDaemonNames()
For each ($name_t; $names_c)
	$cron_o.delete($name_t)
End for each 

// Creates Daemon instance objects, then
// register them under cron's management
$deamonsToInstall_c:=[\
{name: "DaemondSec"; formula: Formula:C1597(daemon_method); interval: 3600}; \
{name: "DaemondEverySec"; formula: Formula:C1597(daemon_method); interval: "every 1800 seconds"}; \
{name: "DaemondEveryMin"; formula: Formula:C1597(daemon_method); interval: "every 60 minutes"}; \
{name: "DaemondEveryHour"; formula: Formula:C1597(daemon_method); interval: "every 2 hours"}; \
{name: "DaemondAtTime"; formula: Formula:C1597(daemon_method); interval: "at 12:00"}; \
{name: "DaemondOnDayAtTime"; formula: Formula:C1597(daemon_method); interval: "on the 7th day at 12:00"}; \
{name: "DaemondEveryWeekAtTime"; formula: Formula:C1597(daemon_method); interval: "every Sunday at 12:00"}\
]

For each ($deamonsToInstall_o; $deamonsToInstall_c)
	$daemon_o:=cs:C1710.Cron.Daemon.new($deamonsToInstall_o.name; $deamonsToInstall_o.formula; $deamonsToInstall_o.interval)
	$cron_o.add($daemon_o)
End for each 

// Set cron management interval to 5 secs.
$cron_o.setInterval(5)

// Log start time
$logEntity_o:=ds:C1482.Log.new()
$logEntity_o.runAt:=String:C10(Current date:C33; ISO date:K1:8; Current time:C178)
$logEntity_o.interval:="== Start =="
$logEntity_o.scheduledAt:=""
$logEntity_o.save()

// then start daemon process(es)
$cron_o.start()

// show List form
Test_showList
