//%attributes = {"invisible":true,"preemptive":"capable"}
/**
* This method is used to execute daemon method in worker process
*
* The reason why I use the executor method instead of directly calling daemon method is 
* to calculate next launch time by the end of the daemon method execution time + interval.
*/

#DECLARE($daemon_o : Object)

var $daemons_c; $indices_c : Collection

If ($daemon_o.parameter=Null:C1517)
	
	$daemon_o.function()
	
Else 
	
	$daemon_o.function($daemon_o.parameter)
	
End if 

// update next launch time
$daemons_c:=Storage:C1525.Cron.Daemons
Use ($daemons_c)
	
	$indices_c:=$daemons_c.indices("name = :1"; $daemon_o.name)
	If ($indices_c.length>0)
		
		$daemons_c[$indices_c[0]].next:=CalcNextLaunchTime($daemon_o.interval)
		$daemons_c[$indices_c[0]].executing:=False:C215
		
	End if 
	
End use 
