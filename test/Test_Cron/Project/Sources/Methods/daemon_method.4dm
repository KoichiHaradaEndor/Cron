//%attributes = {"preemptive":"capable"}
#DECLARE($parameter_o : Object)

var $winRef_l : Integer
var $logEntity_o : cs:C1710.LogEntity

$logEntity_o:=ds:C1482.Log.new()
$logEntity_o.runAt:=String:C10(Current date:C33; ISO date:K1:8; Current time:C178)
$logEntity_o.interval:=This:C1470.interval
$logEntity_o.scheduledAt:=This:C1470.next
$logEntity_o.save()

If (cs:C1710.IV.me.winRef#Null:C1517)
	$winRef_l:=cs:C1710.IV.me.winRef
	CALL FORM:C1391($winRef_l; "Test_query")
	CALL FORM:C1391($winRef_l; "Test_buildIntervalList")
	CALL FORM:C1391($winRef_l; "Test_updateDaemonList")
End if 
