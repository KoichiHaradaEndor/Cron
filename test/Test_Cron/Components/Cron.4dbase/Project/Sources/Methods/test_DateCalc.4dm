//%attributes = {}
var $date_d : Date
var $time_h : Time
var $dateTime_t : Text

$date_d:=Current date:C33
$time_h:=Current time:C178

$dateTime_t:=String:C10($date_d; ISO date:K1:8; $time_h)
ALERT:C41($dateTime_t)

$date_d:=!2021-03-31!
$time_h:=Current time:C178

$dateTime_t:=String:C10($date_d+1; ISO date:K1:8; $time_h)
ALERT:C41($dateTime_t)

$date_d:=!2021-03-31!
$time_h:=?23:55:00?

$dateTime_t:=String:C10($date_d+1; ISO date:K1:8; Time:C179($time_h+600))
ALERT:C41($dateTime_t)
