var $event_o : Object
var $logEntity_o : cs:C1710.LogEntity

$event_o:=FORM Event:C1606

Case of 
	: ($event_o.code=On Clicked:K2:4)
		
		// Log start time
		$logEntity_o:=ds:C1482.Log.new()
		$logEntity_o.runAt:=String:C10(Current date:C33; ISO date:K1:8; Current time:C178)
		$logEntity_o.interval:="== Stop =="
		$logEntity_o.scheduledAt:=""
		$logEntity_o.save()
		
		cs:C1710.Cron.Cron.me.stop()
End case 
