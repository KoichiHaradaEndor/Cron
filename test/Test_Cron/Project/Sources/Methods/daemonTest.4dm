//%attributes = {"shared":true,"preemptive":"capable"}
#DECLARE($parameter_o : Object)

var counter_l : Integer
var $docRef_h : Time
var $message_t : Text
var $path_t : Text

counter_l:=counter_l+1
$message_t:=String:C10(Current date:C33; ISO date:K1:8; Current time:C178)+"\t"\
+String:C10(counter_l+$parameter_o.start)+"\r\n"

$path_t:=System folder:C487(Desktop:K41:16)+Current process name:C1392+".txt"

If (Test path name:C476($path_t)=Is a document:K24:1)
	$docRef_h:=Append document:C265($path_t)
Else 
	$docRef_h:=Create document:C266($path_t)
End if 

If (OK=1)
	SEND PACKET:C103($docRef_h; $message_t)
	CLOSE DOCUMENT:C267($docRef_h)
End if 
