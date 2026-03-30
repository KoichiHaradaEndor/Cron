//%attributes = {}
If (Count parameters:C259=0)
	CALL WORKER:C1389("P:List"; Current method name:C684; "")
Else 
	var $list_o : cs:C1710.ListForm:=cs:C1710.ListForm.new()
	$list_o.run()
End if 
