//%attributes = {}
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
