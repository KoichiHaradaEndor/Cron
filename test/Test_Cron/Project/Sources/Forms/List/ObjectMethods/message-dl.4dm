var $event_o : Object

$event_o:=FORM Event:C1606

Case of 
	: ($event_o.code=On Load:K2:1)
		Form:C1466.messageList:={values: ["all"; "every 60 sec"; "every 2 min"; "every 1 hour"; "at 01:00"; "on the 3rd day at 01:00"]; index: -1; currentValue: ""}
		
	: ($event_o.code=On Data Change:K2:15)
		Test_query()
		
End case 
