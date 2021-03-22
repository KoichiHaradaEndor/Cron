//%attributes = {"invisible":true,"shared":true,"preemptive":"capable"}
/**
* This is public method and used in host application to receive Cron component's class store.
*
* Usage :
* var $cs_o : Object
* $cs_o:=Import Cron
*/

#DECLARE()->$cs_o : Object

$cs_o:=New object:C1471
$cs_o.Cron:=cs:C1710.Cron
$cs_o.Daemon:=cs:C1710.Daemon

// Exporting $cs_o instead of cs because I want to export
// allowed classes only.