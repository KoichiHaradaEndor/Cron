property logFileHandle : 4D:C1709.FileHandle

shared singleton Class constructor()
	
	var $logFile_o : 4D:C1709.File
	
	$logFile_o:=Folder:C1567(fk desktop folder:K87:19).file("log.txt")
	This:C1470.logFileHandle:=
	
Function write($addInfo_t : Text)
	
	var $logContent_t
	