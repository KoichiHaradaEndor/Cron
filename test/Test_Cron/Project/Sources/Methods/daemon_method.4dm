//%attributes = {"preemptive":"capable"}
#DECLARE($parameter_o : Object)

var $winRef_l : Integer

ds:C1482.Log.add(String:C10(This:C1470.interval); This:C1470.next)

If (cs:C1710.IV.me.winRef#Null:C1517)
	$winRef_l:=cs:C1710.IV.me.winRef
	CALL FORM:C1391($winRef_l; Formula:C1597(Form:C1466._query()))
	CALL FORM:C1391($winRef_l; Formula:C1597(Form:C1466._buildIntervalList()))
	CALL FORM:C1391($winRef_l; Formula:C1597(Form:C1466._updateDaemonList()))
End if 
