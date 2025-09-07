//%attributes = {}
If (Count parameters:C259=0)
	
	CALL WORKER:C1389("P:Test_showList"; Current method name:C684; "")
	
Else 
	
	var $winRef_l : Integer
	
	$winRef_l:=Open form window:C675("List")
	DIALOG:C40("List")
	CLOSE WINDOW:C154($winRef_l)
	
End if 
