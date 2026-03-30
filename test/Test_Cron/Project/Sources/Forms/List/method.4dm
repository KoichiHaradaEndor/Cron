var $event_o : Object:=FORM Event:C1606

Case of 
	: ($event_o.code=On Load:K2:1)
		Form:C1466.formOnLoad()
		
	: ($event_o.code=On Unload:K2:2)
		Form:C1466.formOnUnload()
		
End case 
