//%attributes = {}
var $currentValue_t : Text

$currentValue_t:=Form:C1466.messageList.currentValue
If ($currentValue_t="all")
	Form:C1466.Log:=ds:C1482.Log.all().orderBy("dateTime asc")
Else 
	Form:C1466.Log:=ds:C1482.Log.query("message === :1 order by dateTime asc"; $currentValue_t)
End if 
