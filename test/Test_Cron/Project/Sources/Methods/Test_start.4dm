//%attributes = {}
var $names_c; $deamonsToInstall_c : Collection
var $deamonsToInstall_o : Object
var $name_t : Text
var $cron_o : cs:C1710.Cron.Cron

ds:C1482.Log.all().drop()

$cron_o:=cs:C1710.Cron.Cron.me

// Remove currently installed daemons
$names_c:=$cron_o.getDaemonNames()
For each ($name_t; $names_c)
	$cron_o.delete($name_t)
End for each 

// Creates Daemon instance object, then
// register it object under the cron's management
$deamonsToInstall_c:=[\
{name: "DaemondSec"; formula: Formula:C1597(daemon_method); interval: 3600}; \
{name: "DaemondOnDayAtTime"; formula: Formula:C1597(daemon_method); interval: "on the 6th day at 23:20"}; \
{name: "DaemondAtTime"; formula: Formula:C1597(daemon_method); interval: "at 19:15"}; \
{name: "DaemondEveryHour"; formula: Formula:C1597(daemon_method); interval: "every 2 hours"}; \
{name: "DaemondEveryMin"; formula: Formula:C1597(daemon_method); interval: "every 60 minutes"}; \
{name: "DaemondEverySec"; formula: Formula:C1597(daemon_method); interval: "every 1800 seconds"}; \
{name: "DaemondEveryWeekAtTime"; formula: Formula:C1597(daemon_method); interval: "every Saturday at 23:20"}\
]

For each ($deamonsToInstall_o; $deamonsToInstall_c)
	$daemon_o:=cs:C1710.Cron.Daemon.new($deamonsToInstall_o.name; $deamonsToInstall_o.formula; $deamonsToInstall_o.interval)
	$cron_o.add($daemon_o)
End for each 

// Set cron management interval to 5 secs.
$cron_o.setInterval(5)

// then start daemon process(es)
$cron_o.start()

// show List form
CALL WORKER:C1389("P:Test_showList"; Formula:C1597(Test_showList))
