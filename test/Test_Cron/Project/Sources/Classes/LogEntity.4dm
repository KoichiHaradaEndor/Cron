Class extends Entity

local Function get gap() : Time
	
	var $runAt_d; $scheduledAt_d : Date
	var $runAt_h; $scheduledAt_h : Time
	
	If (This:C1470.runAt=Null:C1517) || (This:C1470.scheduledAt=Null:C1517) || (This:C1470.interval="==@")
		return ?00:00:00?
	End if 
	
	$runAt_d:=Date:C102(This:C1470.runAt)
	$runAt_h:=Time:C179(This:C1470.runAt)
	$scheduledAt_d:=Date:C102(This:C1470.scheduledAt)
	$scheduledAt_h:=Time:C179(This:C1470.scheduledAt)
	
	Case of 
		: ($runAt_d=$scheduledAt_d)
			return $runAt_h-$scheduledAt_h
		: ($runAt_d>$scheduledAt_d)
			$runAt_h:=$runAt_h+Time:C179(($runAt_d-$scheduledAt_d)*60*60*24)
			return $runAt_h-$scheduledAt_h
		: ($runAt_d<$scheduledAt_d)
			$scheduledAt_h:=$scheduledAt_h+Time:C179(($scheduledAt_d-$runAt_d)*60*60*24)
			return $scheduledAt_h-$runAt_h
	End case 
	
	
	