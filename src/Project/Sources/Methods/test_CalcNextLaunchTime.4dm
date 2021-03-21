//%attributes = {}
var $interval_t; $next_t : Text
var $interval_l : Integer

$interval_l:=300  // 5 mins later
$next_t:=CalcNextLaunchTime($interval_l)
ALERT:C41($next_t)

$interval_t:="every 5 hrs"
$next_t:=CalcNextLaunchTime($interval_t)
ALERT:C41($interval_t+"\r"+$next_t)

$interval_t:="every 1 hr"
$next_t:=CalcNextLaunchTime($interval_t)
ALERT:C41($interval_t+"\r"+$next_t)

$interval_t:="every 5 mins"
$next_t:=CalcNextLaunchTime($interval_t)
ALERT:C41($interval_t+"\r"+$next_t)

$interval_t:="every 1 min"
$next_t:=CalcNextLaunchTime($interval_t)
ALERT:C41($interval_t+"\r"+$next_t)

$interval_t:="every 600 secs"  // every 10 mins
$next_t:=CalcNextLaunchTime($interval_t)
ALERT:C41($interval_t+"\r"+$next_t)

$interval_t:="at 21:42"
$next_t:=CalcNextLaunchTime($interval_t)
ALERT:C41($interval_t+"\r"+$next_t)

$interval_t:="at 08:56"
$next_t:=CalcNextLaunchTime($interval_t)
ALERT:C41($interval_t+"\r"+$next_t)

$interval_t:="on the 18th day at 23:37"
$next_t:=CalcNextLaunchTime($interval_t)
ALERT:C41($interval_t+"\r"+$next_t)

$interval_t:="on the 19th day at 08:57"
$next_t:=CalcNextLaunchTime($interval_t)
ALERT:C41($interval_t+"\r"+$next_t)

$interval_t:="on the last day at 08:57"
$next_t:=CalcNextLaunchTime($interval_t)
ALERT:C41($interval_t+"\r"+$next_t)
