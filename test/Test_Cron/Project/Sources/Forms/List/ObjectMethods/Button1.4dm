var $event_o : Object

$event_o:=FORM Event:C1606

Case of 
	: ($event_o.code=On Clicked:K2:4)
		cs:C1710.Cron.Cron.me.start()
End case 
