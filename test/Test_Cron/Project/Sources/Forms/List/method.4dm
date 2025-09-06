var $event_o : Object

$event_o:=FORM Event:C1606

Case of 
	: ($event_o.code=On Load:K2:1)
		cs:C1710.IV.me.winRef:=Current form window:C827
		Form:C1466.nextSchedule:=""
		Test_buildIntervalList()
		Test_query()
		
	: ($event_o.code=On Unload:K2:2)
		cs:C1710.IV.me.removeWinRef()
		
End case 
