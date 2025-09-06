Case of 
	: (Form event code:C388=On Load:K2:1)
		
		Form:C1466.Log:=ds:C1482.Log.all().orderBy("daemonName asc, dateTime asc")
		
	: (Form event code:C388=On Unload:K2:2)
		
		
End case 
