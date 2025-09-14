//%attributes = {}
var $names_c; $deamonsToInstall_c : Collection
var $deamonsToInstall_o : Object
var $name_t : Text
var $cron_o : cs:C1710.Cron

$cron_o:=cs:C1710.Cron.me

// Remove currently installed daemons
$names_c:=$cron_o.getDaemonNames()
For each ($name_t; $names_c)
	$cron_o.delete($name_t)
End for each 

// Creates Daemon instance object, then
// register it object under the cron's management
$deamonsToInstall_c:=[\
{name: "DaemondEverySec"; formula: Formula:C1597(DaemonMethod); interval: "every 20 seconds"}\
]
//{name: "DaemondSec"; formula: Formula(DaemonMethod); interval: 60};\
{name: "DaemondOnDayAtTime"; formula: Formula(DaemonMethod); interval: "on the last day at 14:32"}; \
{name: "DaemondAtTime"; formula: Formula(DaemonMethod); interval: "at 14:32"}; \
{name: "DaemondEveryHour"; formula: Formula(DaemonMethod); interval: "every 1 hour"}; \
{name: "DaemondEveryMin"; formula: Formula(DaemonMethod); interval: "every 1 minute"}; \
{name: "DaemondEverySec"; formula: Formula(DaemonMethod); interval: "every 20 seconds"}; \
{name: "DaemondEveryWeekAtTime"; formula: Formula(DaemonMethod); interval: "every Sunday at 14:32"}\

For each ($deamonsToInstall_o; $deamonsToInstall_c)
	$daemon_o:=cs:C1710.Daemon.new($deamonsToInstall_o.name; $deamonsToInstall_o.formula; $deamonsToInstall_o.interval)
	$cron_o.add($daemon_o)
End for each 

// Set cron management interval to 5 secs.
$cron_o.setInterval(5)

// then start daemon process(es)
$cron_o.start()
