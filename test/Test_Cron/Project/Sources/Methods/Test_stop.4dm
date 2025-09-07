//%attributes = {}
var $logEntity_o : cs:C1710.LogEntity

// Log start time
$logEntity_o:=ds:C1482.Log.new()
$logEntity_o.runAt:=String:C10(Current date:C33; ISO date:K1:8; Current time:C178)
$logEntity_o.interval:="== Stop =="
$logEntity_o.scheduledAt:=""
$logEntity_o.save()

cs:C1710.Cron.Cron.me.stop()

If (cs:C1710.IV.me.winRef#Null:C1517)
	CALL FORM:C1391(cs:C1710.IV.me.winRef; "Test_cancel")
	KILL WORKER:C1390("P:Test_showList")
End if 

// Before
If (False:C215)
	var $cs_o; $cron_o : Object
	$cs_o:=Import Cron
	$cron_o:=$cs_o.Cron.new()
	$cron_o.stop()
End if 
