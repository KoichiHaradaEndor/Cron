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

var $daemons_c; $daemonNames_c; $daemonsSnapShot_c; $indices_c; $processes_c : Collection
var $daemon_o; $processes_o : Object
var $status_t; $executorMethod_t; $daemonName_t : Text
var $interval_l; $index_l : Integer
var $quit_b; $run_b; $executing_b : Boolean
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
			
			// Get list of currently running process list
			$processes_o:=Process activity:C1495(Processes only:K5:35)
			$processes_c:=$processes_o.processes
			
			// Make a snapshot of the daemon list (produced with Daemon.add() function) at this point
			$daemons_c:=$cron_o._getDaemons()
			$daemonsSnapShot_c:=$daemons_c.copy()
			
			For each ($daemonSnapShot_o; $daemonsSnapShot_c)
				
				$daemonName_t:=$daemonSnapShot_o._name
				$executing_b:=$daemonSnapShot_o._executing
				$next_t:=$daemonSnapShot_o._next
				$now_t:=String:C10(Current date:C33; ISO date:K1:8; Current time:C178)
				
				// check if a daemon worker process has already been launched and exists
				$index_l:=$processes_c.findIndex(Formula:C1597($1.value.name=$2); $daemonName_t)
				
				$run_b:=False:C215
				Case of 
					: ($next_t="")
						// $next_t can be empty when the daemon interval is NOT supported format
						
					: ($index_l=-1) && ($next_t<=$now_t)
						// The daemon process does not exist at this point.
						// This is the first time call or process has been aborted (crashed).
						// If the process was crashed, executing flag may still be true.
						$cron_o._setDaemonExecutingFlag($daemonName_t; False:C215)
						$run_b:=True:C214
						
					: ($executing_b=True:C214)
						// The formula of the daemon is still running.
						
					: ($next_t<=$now_t)
						$run_b:=True:C214
						
				End case 
				
				If ($run_b)
					CALL WORKER:C1389($daemonName_t; $executorMethod_t; $daemonName_t)
				End if 
				
			End for each 
			
			DELAY PROCESS:C323(Current process:C322; $cron_o._interval*60)
			
	End case 
	
Until ($quit_b)
