//%attributes = {}
#DECLARE($interval_v : Variant; $next_t : Text)

var $logFile_o : 4D:C1709.File
var $logHandle_o : 4D:C1709.FileHandle

$logFile_o:=Folder:C1567(fk desktop folder:K87:19).file("log.txt")
$logHandle_o:=$logFile_o.open("append")
$logHandle_o.writeLine(String:C10(Current date:C33; ISO date:K1:8; Current time:C178)+"\t"+String:C10($interval_v)+"\t"+String:C10($next_t))

