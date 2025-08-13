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

var $daemons_c; $indices_c : Collection
var $daemon_o : Object
var $status_t; $executorMethod_t : Text
var $interval_l : Integer
var $quit_b : Boolean
var $next_t; $now_t : Text

$quit_b:=False:C215
$executorMethod_t:="DaemonExecutor"

Repeat 
	
	// Check if the daemon manager should stop or proceed executing
	Use (Storage:C1525.Cron)
		
		$status_t:=Storage:C1525.Cron.Status
		
	End use 
	
	Case of 
		: ($status_t="Stopped")
			
			// Kill all daemon processes
			Use (Storage:C1525.Cron.Daemons)
				
				$daemons_c:=Storage:C1525.Cron.Daemons.copy()
				
			End use 
			
			For each ($daemon_o; $daemons_c)
				
				KILL WORKER:C1390($daemon_o.name)
				
			End for each 
			
			$quit_b:=True:C214  // to stop looping
			KILL WORKER:C1390  // then kill this worker process
			
		Else 
			
			// Make a copy of the daemon list (produced with Daemon.add() function) at this point
			Use (Storage:C1525.Cron.Daemons)
				
				$daemons_c:=Storage:C1525.Cron.Daemons.copy()
				
			End use 
			
			// and remove currently executing daemons
			$daemons_c:=$daemons_c.query("executing = :1"; False:C215)
			For each ($daemon_o; $daemons_c)
				
				$next_t:=$daemon_o.next
				$now_t:=String:C10(Current date:C33; ISO date:K1:8; Current time:C178)
				If ($next_t#"") & ($next_t<=$now_t)
					// $next_t can be empty when the daemon interval is NOT supported format
					
					// Set executing flag to true to avoid duplicate launch
					// The flag will be set again in the executor method
					Use (Storage:C1525.Cron.Daemons)
						
						$indices_c:=Storage:C1525.Cron.Daemons.indices("name = :1"; $daemon_o.name)
						If ($indices_c.length>0)
							
							Storage:C1525.Cron.Daemons[$indices_c[0]].executing:=True:C214
							
						End if 
						
					End use 
					
					CALL WORKER:C1389($daemon_o.name; $executorMethod_t; $daemon_o)
					
				End if 
				
			End for each 
			
			Use (Storage:C1525.Cron)
				
				$interval_l:=Storage:C1525.Cron.Interval
				
			End use 
			
			DELAY PROCESS:C323(Current process:C322; $interval_l*60)
			
	End case 
	
Until ($quit_b)
