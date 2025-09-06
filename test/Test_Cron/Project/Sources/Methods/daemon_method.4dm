//%attributes = {"preemptive":"capable"}
#DECLARE($parameter_o : Object)

var $logEntity_o : cs:C1710.LogEntity

$logEntity_o:=ds:C1482.Log.new()
$logEntity_o.message:=$parameter_o.message || ""
$logEntity_o.dateTime:=String:C10(Current date:C33; ISO date:K1:8; Current time:C178)
$logEntity_o.save()

If (cs:C1710.IV.me.winRef#Null:C1517)
	CALL FORM:C1391(cs:C1710.IV.me.winRef; Formula:C1597(Test_query))
End if 
