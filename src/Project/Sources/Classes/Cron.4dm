/**
* The "Cron" class is used to manage user daemon processes
*/

property _status : Text
property _interval : Integer
property _daemons : Collection

shared singleton Class constructor
	
	This:C1470._status:="Initialized"
	This:C1470._interval:=60  // default interval is 60 sec
	This:C1470._daemons:=New shared collection:C1527
	
shared Function add($daemon_o : cs:C1710.Daemon) : cs:C1710.Cron
	
/**
* Register a given daemon under cron's management
* The daemon parameter must have 'name' property in order to identify among all the others.
* If the daemon.name already registered, it will be overwritten.
*/
	
	var $copiedDaemon_o : Object
	var $daemons_c : Collection
	var $type_l; $index_l : Integer
	
	$type_l:=Value type:C1509($daemon_o._interval)
	
	// set next launch time
	Case of 
		: ($type_l=Is text:K8:3)
			If ($daemon_o._interval="every @")
				$daemon_o._updateNextLaunchTime("now")
			Else 
				$daemon_o._updateNextLaunchTime()
			End if 
		: ($type_l=Is real:K8:4) || ($type_l=Is longint:K8:6)
			$daemon_o._updateNextLaunchTime("now")
	End case 
	
	// set executing flag to False
	$daemon_o._setExecuting(False:C215)
	
	$daemons_c:=This:C1470._daemons
	$copiedDaemon_o:=OB Copy:C1225($daemon_o; ck shared:K85:29; $daemons_c)
	
	$index_l:=$daemons_c.findIndex(Formula:C1597($1.value._name=$2); $copiedDaemon_o._name)
	If ($index_l=-1)
		// The daemon has not been registered
		$daemons_c.push($copiedDaemon_o)
	Else 
		// The daemon which has the same name exists,
		// then replace with it
		$daemons_c[$index_l]:=$copiedDaemon_o
	End if 
	
	return This:C1470
	
shared Function delete($name_t : Text) : cs:C1710.Cron
	
/**
* Remove the specified daemon from Daemons list
* If the daemon that has the same name does not exist, it does nothing.
*/
	
	var $daemons_c; $indices_c : Collection
	var $index_l : Integer
	
	$daemons_c:=This:C1470._daemons
	$indices_c:=$daemons_c.indices("_name = :1"; $name_t)
	
	For ($index_l; $indices_c.length-1; 0; -1)
		$daemons_c.remove($indices_c[$index_l])
	End for 
	
	return This:C1470
	
shared Function start() : cs:C1710.Cron
	
/**
* Call this function to start cron manager worker process, so the daemon processes.
*/
	
	This:C1470._status:="Executing"
	CALL WORKER:C1389("crond (Cron component)"; "DaemonManager")
	return This:C1470
	
shared Function stop() : cs:C1710.Cron
	
/**
* Call this function to stop cron manager worker process.
*/
	
	This:C1470._status:="Stopped"
	return This:C1470
	
shared Function setInterval($interval_l : Integer) : cs:C1710.Cron
	
/**
* This function is used to set the Cron manager execution interval, in second
*/
	
	This:C1470._interval:=Abs:C99($interval_l)
	return This:C1470
	
shared Function _getStatus() : Text
	
	return This:C1470._status
	
shared Function _getDaemons() : Collection
	
	return This:C1470._daemons
	
shared Function _setDaemonExecutingFlag($name_t : Text; $flag_b : Boolean)
	
	var $index_l : Integer
	var $daemon_o : cs:C1710.Daemon
	
	$index_l:=This:C1470._daemons.findIndex(Formula:C1597($1.value._name=$2); $name_t)
	If ($index_l=-1)
		return 
	End if 
	
	$daemon_o:=This:C1470._daemons[$index_l]
	$daemon_o._setExecuting($flag_b)
	
shared Function _updateDaemonNextLaunchTime($name_t : Text)
	
	var $index_l : Integer
	var $daemon_o : cs:C1710.Daemon
	
	$index_l:=This:C1470._daemons.findIndex(Formula:C1597($1.value._name=$2); $name_t)
	If ($index_l=-1)
		return 
	End if 
	
	$daemon_o:=This:C1470._daemons[$index_l]
	$daemon_o._updateNextLaunchTime()
	