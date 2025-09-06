//%attributes = {"invisible":true,"preemptive":"capable"}
/**
* This method is used to execute daemon method in worker process
*
* The reason why I use the executor method instead of directly calling daemon method is 
* to calculate next launch time by the end of the daemon method execution time + interval.
*/

#DECLARE($daemonName_t : Text)

var $daemons_c; $indices_c : Collection
var $index_l : Integer
var $daemon_o : cs:C1710.Daemon
var $cron_o : cs:C1710.Cron

$cron_o:=cs:C1710.Cron.me
$daemons_c:=$cron_o._getDaemons()
$index_l:=$daemons_c.findIndex(Formula:C1597($1.value._name=$2); $daemonName_t)
If ($index_l=-1)
	return 
End if 

$daemon_o:=$daemons_c[$index_l]
If ($daemon_o._executing=True:C214)
	return 
End if 

// Set executing flag to true to avoid duplicate launch
$cron_o._setDaemonExecutingFlag($daemonSnapShot_o._name; True:C214)

// Call daemon function
If ($daemon_o._parameter=Null:C1517)
	$daemon_o._function()
Else 
	$daemon_o._function($daemon_o._parameter)
End if 

// update next launch time
$cron_o._updateDaemonNextLaunchTime($daemonName_t)
$cron_o._setDaemonExecutingFlag($daemonName_t; False:C215)
