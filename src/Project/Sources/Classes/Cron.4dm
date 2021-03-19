/**
* The "Cron" class is used to manage user daemon processes
*
* A daemon is a method that is executed in a dedicated worker process repeatedly.
* The method, worker name and interval are specified when Cron.add() function is called.
* The method will be executed in the named worker process repeatedly using the specified interval.
* So the method need not contain loop structure.
*
* Note : The daemon name is used as the name of corresponding worker name.
* So avoid using the same name with other worker names.
* You may want to add "d" character at the end of the name to indicate it is daemon worker process.
*/

Class constructor
	
/**
* Initialize shared objects and collections using Singleton pattern
*/
	
	Use (Storage:C1525)
		
		If (Storage:C1525.Cron=Null:C1517)
			
			Storage:C1525.Cron:=New shared object:C1526
			
		End if 
		
	End use 
	
	Use (Storage:C1525.Cron)
		
		If (Storage:C1525.Cron.Daemons=Null:C1517)
			
			Storage:C1525.Cron.Daemons:=New shared collection:C1527
			
		End if 
		
		If (Storage:C1525.Cron.Status=Null:C1517)
			
			Storage:C1525.Cron.Status:="Initialized"
			
		End if 
		
		If (Storage:C1525.Cron.Interval=Null:C1517)
			
			Storage:C1525.Cron.Interval:=60  // default interval is 60 sec
			
		End if 
		
	End use 
	
Function add($daemon_o : Object)->$this_o : cs:C1710.Cron
	
/**
* The daemon object parameter consists of:
* name : Text - The name of the daemon process, used to identify among all the other daemons and as worker name
* method : Text - Method name that will be executed in daemon worker
* interval : Integer - Interval between the next daemon worker is called, in second
* parameter : Object - Parameter to be passed to the method (optional)
*
* Note1 : The existence of the method name is NOT checked in this component.
* It is developer's responsible.
*
* Note2 : The method in the host application, intended to use as daemon, must be shared with components.
*/
	
	ASSERT:C1129($daemon_o#Null:C1517)
	ASSERT:C1129($daemon_o.name#Null:C1517; "The name attribute must exists")
	ASSERT:C1129(Value type:C1509($daemon_o.name)=Is text:K8:3; "The name attribute must be text type")
	ASSERT:C1129($daemon_o.name#""; "The name attribute must not be empty string")
	ASSERT:C1129($daemon_o.method#Null:C1517; "The method attribute must exists")
	ASSERT:C1129(Value type:C1509($daemon_o.method)=Is text:K8:3; "The method attribute must be text type")
	ASSERT:C1129($daemon_o.method#""; "The method attribute must not be empty string")
	ASSERT:C1129($daemon_o.interval#Null:C1517; "The interval attribute must exists")
	
/**
* Register a given daemon under cron's management
* The daemon parameter must have 'name' property in order to identify among all the others.
* If the daemon.name already registered, it will be overwritten.
*/
	
	var $copiedDaemon_o : Object
	var $daemons_c; $indices_c : Collection
	
	$daemon_o.next:=CalcNextLaunchTime($daemon_o.interval)  // set next launch time
	$daemon_o.executing:=False:C215  // set currently the daemon method is executing flag to false
	$copiedDaemon_o:=OB Copy:C1225($daemon_o; ck shared:K85:29; Storage:C1525.Cron.Daemons)
	
	$daemons_c:=Storage:C1525.Cron.Daemons
	Use ($daemons_c)
		
		$indices_c:=$daemons_c.indices("name = :1"; $copiedDaemon_o.name)
		If ($indices_c.length=0)
			
			// The cron has not been registered
			$daemons_c.push($copiedDaemon_o)
			
		Else 
			
			// The cron which has the same name exists,
			// then replace with it
			$daemons_c[$indices_c[0]]:=$copiedDaemon_o
			
		End if 
		
	End use 
	
	$this_o:=This:C1470
	
Function delete($name_t : Text)->$this_o : cs:C1710.Cron
	
/**
* Remove the specified daemon from Daemons list
* If the daemon that has the same name does not exist, it does nothing.
*/
	
	var $daemons_c; $indices_c : Collection
	var $index_l : Integer
	
	$daemons_c:=Storage:C1525.Cron.Daemons
	Use ($daemons_c)
		
		$indices_c:=$daemons_c.indices("name = :1"; $name_t)
		
		For ($index_l; $indices_c.length-1; 0; -1)
			
			$daemons_c.remove($indices_c[$index_l])
			
		End for 
		
	End use 
	
	$this_o:=This:C1470
	
Function start()->$this_o : cs:C1710.Cron
	
/**
* Call this function to start cron manager worker process, so the daemon processes.
*/
	
	Use (Storage:C1525.Cron)
		
		Storage:C1525.Cron.Status:="Executing"
		
	End use 
	
	CALL WORKER:C1389("crond (Cron component)"; "DaemonManager")
	
	$this_o:=This:C1470
	
Function stop()->$this_o : cs:C1710.Cron
	
/**
* Call this function to stop cron manager worker process.
*/
	
	Use (Storage:C1525.Cron)
		
		Storage:C1525.Cron.Status:="Stopped"
		
	End use 
	
	$this_o:=This:C1470
	
Function setInterval($interval_l : Integer)->$this_o : cs:C1710.Cron
	
/**
* This function is used to set the Cron manager execution interval, in second
*/
	
	Use (Storage:C1525.Cron)
		
		Storage:C1525.Cron.Interval:=$interval_l
		
	End use 
	
	$this_o:=This:C1470
	