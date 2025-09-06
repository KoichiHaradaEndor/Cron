var $event_o : Object
var $daemons_c : Collection

$event_o:=FORM Event:C1606

Case of 
	: ($event_o.code=On Selection Change:K2:29)
		
		If (Form:C1466.LogSelectedItem=Null:C1517)
			return 
		End if 
		
		$daemons_c:=cs:C1710.Cron.Cron.me._getDaemons()
		$daemons_c:=$daemons_c.query("_interval === :1 OR _interval === :2 order by _next desc"; $interval_t; Num:C11($interval_t))
		Form:C1466.nextSchedule:=($daemons_c.length=0) ? "" : $daemons_c[0].next
		
End case 
