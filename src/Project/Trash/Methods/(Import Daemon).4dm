//%attributes = {"invisible":true,"shared":true,"preemptive":"capable"}
/**
* This is public method and used in host application to receive Daemon class object.
*
* Usage :
* var $daemon_o : Object
* $daemon_o:=Import Daemon
* $cron_o:=$cs_o.new()
*/

#DECLARE()->$cs_o : cs:C1710.Daemon

$cs_o:=cs:C1710.Daemon
