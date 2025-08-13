//%attributes = {"invisible":true,"preemptive":"capable"}
/**
* This method is used to calculate next launch time
* When the interval parameter is numeric type, the value is expressed in second.
* When it is text type, it can be as follow:
* "now" => the daemon is executed immediately
* "at hh:mm" => the daemon is executed at hh:mm everyday (24-hour notation, 00:00 - 23:59)
* "on the nnth day at hh:mm" => the daemon is executed on the day at the time every month
* where "nn" can be the day of the month (numeric) or "last" that indicates the last day of the month
* "every nn {hours | hrs | minutes | mins | seconds | secs}" => the daemon is executed after given interval
*
* Note : when using "on the nn day at hh:mm" format, day numbers of the end of months are not taken into account.
* So please use "last" keyword when "nn" should indicate 29th day and after.
*/

#DECLARE($interval_v : Variant)->$next_t : Text

var $valueType_l; $interval_l : Integer
var $timePattern_t; $dayPattern_t; $interval_t : Text
var $day_t; $time_t : Text
var $current_d; $nextDate_d : Date
var $value_t; $unit_t : Text
var $currentYear_l; $currentMonth_l : Integer
var $time_h : Time
var $lastDayNum_l : Integer

$valueType_l:=Value type:C1509($interval_v)
$next_t:=""

Case of 
	: ($valueType_l=Is longint:K8:6) | ($valueType_l=Is real:K8:4)
		
		// $interval_v is interval in second
		$interval_l:=Abs:C99($interval_v)
		If ($interval_l>0)
			
			$next_t:=String:C10(Current date:C33; ISO date:K1:8; Time:C179(Current time:C178+$interval_l))
			
		End if 
		
	: ($valueType_l=Is text:K8:3)
		
		$timePattern_t:="((?:[01][0-9]|2[0-3]):[0-5][0-9])"  // 00:00 - 23:59
		$dayPattern_t:="((?:[1-9]|0[1-9]|[12][0-9]|3[01])|(?:last))"
		
		ARRAY LONGINT:C221($positons_al; 0)
		ARRAY LONGINT:C221($lengths_al; 0)
		
		$interval_t:=$interval_v
		Case of 
			: ($interval_t="now")
				
				// for use the first launch
				// **DO NOT USE THE "now" KEYWORD TO INDICATE INTERVAL IN  DAEMON.NEW().**
				// **IF YOU DO SO, THE CRON METHOD WILL BE CALLED CONTINUEOUSLY WITHOUT INTERVAL.**
				$next_t:=String:C10(Current date:C33; ISO date:K1:8; Current time:C178)
				
			: (Match regex:C1019("^on (?:the |)"+$dayPattern_t+"(?:st|nd|rd|th|) day at "+$timePattern_t+"$"; $interval_t; 1; $positons_al; $lengths_al))
				
				// "on the nn day at hh:mm" => the daemon is executed on the specified day at the specified time every month
				// where "nn" can be the day of the month (numeric) or "last" that indicates the last day of the month
				
				$day_t:=Substring:C12($interval_t; $positons_al{1}; $lengths_al{1})
				$time_t:=Substring:C12($interval_t; $positons_al{2}; $lengths_al{2})
				
				$current_d:=Current date:C33
				$currentYear_l:=Year of:C25($current_d)
				$currentMonth_l:=Month of:C24($current_d)
				If ($day_t="last")
					
					$lastDayNum_l:=GetLastDayNumber($currentYear_l; $currentMonth_l)
					$nextDate_d:=Date:C102(String:C10($currentYear_l)+"/"+String:C10($currentMonth_l)+"/"+String:C10($lastDayNum_l))
					
				Else 
					
					$nextDate_d:=Date:C102(String:C10($currentYear_l)+"/"+String:C10($currentMonth_l)+"/"+$day_t)
					
				End if 
				
				Case of 
					: ($nextDate_d<$current_d)
						
						// In case today is bigger than the specified day
						// add one month
						$nextDate_d:=Add to date:C393($nextDate_d; 0; 1; 0)
						
					: ($nextDate_d>$current_d)
						
						// In case today is lesser than the specified day
						//  use the date as is
						
					Else 
						
						// In case today is the specified day
						// then compare the time
						If ($time_t<=String:C10(Current time:C178; HH MM:K7:2))
							
							// Comparing string format since I do not want to take seconds into account
							
							// If the given time has already passed for today
							// set the next launch time for next month
							If ($day_t="last")
								
								If ($currentMonth_l=12)
									
									$currentYear_l:=$currentYear_l+1
									$currentMonth_l:=1
									
								End if 
								
								$lastDayNum_l:=GetLastDayNumber($currentYear_l; $currentMonth_l)
								$nextDate_d:=Date:C102(String:C10($currentYear_l)+"/"+String:C10($currentMonth_l)+"/"+String:C10($lastDayNum_l))
								
							Else 
								
								$nextDate_d:=Add to date:C393($nextDate_d; 0; 1; 0)
								
							End if 
							
						End if 
						
				End case 
				
				$time_h:=Time:C179($time_t)
				$next_t:=String:C10($nextDate_d; ISO date:K1:8; $time_h)
				
			: (Match regex:C1019("^at "+$timePattern_t+"$"; $interval_t; 1; $positons_al; $lengths_al))
				
				// "at hh:mm" => the daemon is executed at hh:mm everyday (24-hour notation, 00:00 - 23:59)
				
				$time_t:=Substring:C12($interval_t; $positons_al{1}; $lengths_al{1})
				
				$current_d:=Current date:C33
				If ($time_t<=String:C10(Current time:C178; HH MM:K7:2))
					
					// Comparing string format since I do not want to take seconds into account
					
					// If the given time has already passed for today
					// set the next launch time for tomorrow
					$current_d:=$current_d+1
					
				End if 
				
				$next_t:=String:C10($current_d; ISO date:K1:8; Time:C179($time_t))
				
			: (Match regex:C1019("^every (\\d+) (hours|hrs|hour|hr|minutes|mins|minute|min|seconds|secs|second|sec)$"; $interval_t; 1; $positons_al; $lengths_al))
				
				// "every nn {hours | minutes | seconds}" => the daemon is executed after given interval
				
				$value_t:=Substring:C12($interval_t; $positons_al{1}; $lengths_al{1})
				$unit_t:=Substring:C12($interval_t; $positons_al{2}; $lengths_al{2})
				
				// convert given value in second
				Case of 
					: ($unit_t="hours") | ($unit_t="hrs") | ($unit_t="hour") | ($unit_t="hr")
						
						$interval_l:=Num:C11($value_t)*60*60
						
					: ($unit_t="minutes") | ($unit_t="mins") | ($unit_t="minute") | ($unit_t="min")
						
						$interval_l:=Num:C11($value_t)*60
						
					: ($unit_t="seconds") | ($unit_t="secs") | ($unit_t="second") | ($unit_t="sec")
						
						$interval_l:=Num:C11($value_t)
						
				End case 
				
				$next_t:=String:C10(Current date:C33; ISO date:K1:8; Time:C179(Current time:C178+$interval_l))
				
		End case 
		
End case 

