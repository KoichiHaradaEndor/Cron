//%attributes = {}
#DECLARE() : Text

var $runAt_h; $scheduledAt_h : Time

If (This:C1470.runAt=Null:C1517) || (This:C1470.scheduledAt=Null:C1517) || (This:C1470.interval="==@")
	return "#FFFFFF"
End if 

$runAt_h:=Time:C179(This:C1470.runAt)
$scheduledAt_h:=Time:C179(This:C1470.scheduledAt)

If (($runAt_h-$scheduledAt_h)>5)
	return "#000000"
Else 
	return "#FFFFFF"
End if 
