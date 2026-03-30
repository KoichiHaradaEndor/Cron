//%attributes = {}

// Log stop time
ds:C1482.Log.add("== Stop =="; "")
cs:C1710.Cron.Cron.me.stop()

If (cs:C1710.IV.me.winRef#Null:C1517)
	CALL FORM:C1391(cs:C1710.IV.me.winRef; Formula:C1597(CANCEL:C270))
	KILL WORKER:C1390("P:Test_showList")
End if 

