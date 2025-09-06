//%attributes = {}
cs:C1710.Cron.Cron.me.stop()

// Before
If (False:C215)
	var $cs_o; $cron_o : Object
	$cs_o:=Import Cron
	$cron_o:=$cs_o.Cron.new()
	$cron_o.stop()
End if 
