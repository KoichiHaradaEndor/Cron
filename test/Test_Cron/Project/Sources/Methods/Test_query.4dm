//%attributes = {}
var $interval_t; $orderBy_t : Text
var $daemons_c : Collection
var $logSelInterval_o; $logSelStartEnd_o : cs:C1710.LogSelection

$orderBy_t:="order asc, interval asc"
$interval_t:=Form:C1466.intervalList.currentValue
Case of 
	: (Form:C1466.intervalList.currentValue=Null:C1517)
		Form:C1466.Log:=ds:C1482.Log.all().orderBy($orderBy_t)
	: ($interval_t="") || ($interval_t="all")
		Form:C1466.Log:=ds:C1482.Log.all().orderBy($orderBy_t)
	Else 
		$logSelInterval_o:=ds:C1482.Log.query("interval === :1"; $interval_t)
		$logSelStartEnd_o:=ds:C1482.Log.query("interval = :1"; "==@")
		Form:C1466.Log:=$logSelInterval_o.or($logSelStartEnd_o).orderBy($orderBy_t)
End case 

$daemons_c:=cs:C1710.Cron.Cron.me._getDaemons()
$daemons_c:=$daemons_c.query("_interval === :1 OR _interval === :2 order by _next desc"; $interval_t; Num:C11($interval_t))
Form:C1466.nextSchedule:=($daemons_c.length=0) ? "" : $daemons_c[0].next
