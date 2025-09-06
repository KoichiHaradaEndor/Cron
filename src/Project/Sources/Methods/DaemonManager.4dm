//%attributes = {"invisible":true,"preemptive":"capable"}
/**
* This method is used to manage daemon processes
* The purpose of this method is to
* - check if a daemon in the daemon list should be invoked (calculated by interval)
* - call dedicated worker for the daemon if the above is true
*
* In this method, I do not check if each attributes are not null since
* it has already been checked when added to the daemon list via Daemon.add() function.
*/

var $daemons_c; $daemonNames_c; $daemonsSnapShot_c; $indices_c : Collection
var $daemon_o : Object
var $status_t; $executorMethod_t; $daemonName_t : Text
var $interval_l; $index_l : Integer
var $quit_b : Boolean
var $next_t; $now_t : Text
var $cron_o : cs:C1710.Cron

$quit_b:=False:C215
$executorMethod_t:="DaemonExecutor"
$cron_o:=cs:C1710.Cron.me

Repeat 
	
	// Check if the daemon manager should stop or proceed executing
	$status_t:=$cron_o._getStatus()
	Case of 
		: ($status_t="Stopped")
			
			// Kill all daemon processes
			$daemonNames_c:=$cron_o.getDaemonNames()
			For each ($daemonName_t; $daemonNames_c)
				KILL WORKER:C1390($daemonName_t)
			End for each 
			
			$quit_b:=True:C214  // to stop looping
			KILL WORKER:C1390  // then kill this worker process
			
		Else 
			
			// Make a snapshot of the daemon list (produced with Daemon.add() function) at this point
			$daemons_c:=$cron_o._getDaemons()
			$daemonsSnapShot_c:=$daemons_c.copy()
			
			// and picks only daemons whose executing property equals to False
			$daemonsSnapShot_c:=$daemonsSnapShot_c.query("_executing = :1"; False:C215)
			For each ($daemonSnapShot_o; $daemonsSnapShot_c)
				
				$next_t:=$daemonSnapShot_o._next
				$now_t:=String:C10(Current date:C33; ISO date:K1:8; Current time:C178)
				If ($next_t#"") & ($next_t<=$now_t)
					// $next_t can be empty when the daemon interval is NOT supported format
					
					CALL WORKER:C1389($daemonSnapShot_o._name; $executorMethod_t; $daemonSnapShot_o._name)
				End if 
				
			End for each 
			
			DELAY PROCESS:C323(Current process:C322; $cron_o._interval*60)
			
	End case 
	
Until ($quit_b)
