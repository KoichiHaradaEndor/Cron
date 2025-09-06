//%attributes = {}
#DECLARE($addInfo_t : Text)

var $logFile_o : 4D:C1709.File
var $logHandle_o : 4D:C1709.FileHandle

$logFile_o:=Folder:C1567(fk desktop folder:K87:19).file("log.txt")
$logHandle_o:=$logFile_o.open("append")
$logHandle_o.writeLine(Timestamp:C1445+"\t"+$addInfo_t)

