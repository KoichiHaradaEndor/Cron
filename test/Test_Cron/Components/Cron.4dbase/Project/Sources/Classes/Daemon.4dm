/**
* The Daemon class is used to store daemon process information,
* especially its name that is also used for worker process name, 
* function that is executed in the dedicated worker repeatedly,
* interval that defines when the daemon should be executed,
* and parameter object which is passed to the function when it is executed each time.
*
* A daemon executed in a dedicated worker process repeatedly.
* The function, worker name and interval are specified when Cron.add() function is called.
* The function will be executed in the named worker process repeatedly using the specified interval.
* So the function need not contain loop structure.
*
* Note : The daemon name is used as the name for the corresponding worker name.
* So avoid using the same name with other worker names.
* Otherwise it will be overwritten when added to the daemon list.
* You may want to add "d" character at the end of the name to indicate it is daemon worker process.
*/

property _name : Text
property _function : 4D:C1709.Function
property _interval : Variant
property _parameter : Object

property _next : Text
property _executing : Boolean

Class constructor(\
$name_t : Text; \
$function_o : 4D:C1709.Function; \
$interval_v : Variant; \
$parameter_o : Object)
	
/**
* The Daemon class instance object consists of
* _name : Text - The name of the daemon process, used to identify among all the other daemons and as worker name
* _function : 4D.Function - Function object that will be executed in daemon worker
* _interval : Text or Integer - Interval between the next daemon worker is called
* _parameter : Object - Parameter to be passed to the function (optional)
*/
	
	ASSERT:C1129(Count parameters:C259>=3; "Lack of parameters")
	ASSERT:C1129(Value type:C1509($name_t)=Is text:K8:3; "The name parameter must be text type")
	ASSERT:C1129($name_t#""; "The name parameter must not be empty string")
	ASSERT:C1129(OB Instance of:C1731($function_o; 4D:C1709.Function); "The function parameter must be instance of 4D.Function")
	ASSERT:C1129((Value type:C1509($interval_v)=Is text:K8:3) || (Value type:C1509($interval_v)=Is longint:K8:6) || (Value type:C1509($interval_v)=Is real:K8:4); "The interval parameter must be text ot numeric type")
	Case of 
		: (Value type:C1509($interval_v)=Is text:K8:3)
			ASSERT:C1129(This:C1470._calcNextLaunchTime($interval_v)#""; "The interval parameter is incorrect format")
		: ((Value type:C1509($interval_v)=Is longint:K8:6) || (Value type:C1509($interval_v)=Is real:K8:4))
			ASSERT:C1129($interval_v#0; "The interval parameter must not be zero")
	End case 
	
	This:C1470._name:=$name_t
	This:C1470._function:=$function_o
	This:C1470._interval:=$interval_v
	If (Count parameters:C259>=4)
		This:C1470._parameter:=$parameter_o
	End if 
	This:C1470._executing:=False:C215
	
Function get name() : Text
	
	return This:C1470._name
	
Function get interval() : Variant
	
	return This:C1470._interval
	
Function get next() : Text
	
	return This:C1470._next
	
Function _calcNextLaunchTime($interval_v : Variant) : Text
	
/**
* This method is used to calculate next launch time
* When the interval parameter is numeric type, the value is expressed in second.
* When it is text type, it can be as follow:
* "now" => the daemon is executed immediately
*   **DO NOT USE THE "now" KEYWORD TO INDICATE INTERVAL IN DAEMON.NEW().**
*   **IF YOU DO SO, THE CRON METHOD WILL BE CALLED CONTINUEOUSLY WITHOUT INTERVAL.**
* "at hh:mm" => the daemon is executed at hh:mm everyday (24-hour notation, 00:00 - 23:59)
* "on the nnth day at hh:mm" => the daemon is executed on the day at the time every month
* where "nn" can be the day of the month (numeric) or "last" that indicates the last day of the month
* "every nn {hours | hrs | minutes | mins | seconds | secs}" => the daemon is executed after given interval
* "every xxday at hh:mm" => the daemon is executed on the specified day of week at the specified time, where the xxday is the day name.
*
* Note : when using "on the nn day at hh:mm" format, day numbers of the end of months are not taken into account.
* So please use "last" keyword when "nn" should indicate 29th day and after.
*/
	
	var $valueType_l; $interval_l : Integer
	var $timePattern_t; $dayPattern_t; $dayNamePattern_t; $interval_t; $next_t : Text
	var $day_t; $time_t; $dayName_t : Text
	var $current_d; $nextDate_d : Date
	var $value_t; $unit_t : Text
	var $currentYear_l; $currentMonth_l : Integer
	var $time_h : Time
	var $lastDayNum_l : Integer
	
	$interval_v:=$interval_v || This:C1470._interval
	$valueType_l:=Value type:C1509($interval_v)
	$next_t:=""
	
	Case of 
		: ($valueType_l=Is longint:K8:6) | ($valueType_l=Is real:K8:4)
			
			// $interval_v is interval in second
			$interval_l:=Abs:C99($interval_v)
			$next_t:=String:C10(Current date:C33; ISO date:K1:8; Time:C179(Current time:C178+$interval_l))
			
		: ($valueType_l=Is text:K8:3)
			
			$timePattern_t:="((?:[01][0-9]|2[0-3]):[0-5][0-9])"  // 00:00 - 23:59
			$dayPattern_t:="((?:[1-9]|0[1-9]|[12][0-9]|3[01])|(?:last))"
			$dayNamePattern_t:="(Sun(?:day)*|Mon(?:day)*|Tue(?:day)*|Wed(?:nesday)*|Thu(?:rsday)*|Fri(?:day)*|Sat(?:urday)*)"
			
			ARRAY LONGINT:C221($positons_al; 0)
			ARRAY LONGINT:C221($lengths_al; 0)
			
			$interval_t:=$interval_v
			Case of 
				: ($interval_t="now")
					
					// use for the first launch
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
						$lastDayNum_l:=This:C1470._getLastDayNumber($currentYear_l; $currentMonth_l)
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
								
								// If the given time has already past for today
								// set the next launch time for next month
								If ($day_t="last")
									
									$currentMonth_l+=1
									If ($currentMonth_l=12)
										$currentYear_l:=$currentYear_l+1
										$currentMonth_l:=1
									End if 
									
									$lastDayNum_l:=This:C1470._getLastDayNumber($currentYear_l; $currentMonth_l)
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
					
				: (Match regex:C1019("^every "+$dayNamePattern_t+" at "+$timePattern_t+"$"; $interval_t; 1; $positons_al; $lengths_al))
					
					var $dayNumberToday_l; $dayNumberNext_l; $addDayNum_l : Integer
					
					// "every xxday at hh:mm" => the daemon is executed on the specified day of week at the specified time, where the xxday is the day name.
					$dayName_t:=Substring:C12($interval_t; $positons_al{1}; $lengths_al{1})
					$time_t:=Substring:C12($interval_t; $positons_al{2}; $lengths_al{2})
					
					$current_d:=Current date:C33
					$dayNumberToday_l:=Day number:C114($current_d)
					$dayNumberNext_l:=(["Sunday"; "Monday"; "Tuesday"; "Wednesday"; "Thursday"; "Friday"; "Saturday"].indexOf($dayName_t+"@"))+1
					
					Case of 
						: ($dayNumberNext_l<$dayNumberToday_l)
							
							$addDayNum_l:=7-$dayNumberToday_l+$dayNumberNext_l
							$nextDate_d:=Add to date:C393($current_d; 0; 0; $addDayNum_l)
							
						: ($dayNumberNext_l>$dayNumberToday_l)
							
							$addDayNum_l:=$dayNumberNext_l-$dayNumberToday_l
							$nextDate_d:=Add to date:C393($current_d; 0; 0; $addDayNum_l)
							
						: ($dayNumberNext_l=$dayNumberToday_l)
							
							$nextDate_d:=$current_d
							If ($time_t<=String:C10(Current time:C178; HH MM:K7:2))
								
								// Comparing string format since I do not want to take seconds into account
								// If the given time has already passed for today
								// set the next launch time for next week
								$nextDate_d:=Add to date:C393($nextDate_d; 0; 0; 7)
								
							End if 
							
					End case 
					
					$time_h:=Time:C179($time_t)
					$next_t:=String:C10($nextDate_d; ISO date:K1:8; $time_h)
					
			End case 
			
	End case 
	
	return $next_t
	
Function _updateNextLaunchTime($interval_v : Variant)
	
	This:C1470._next:=This:C1470._calcNextLaunchTime($interval_v)
	
Function _setExecuting($executing_b : Boolean)
	
	This:C1470._executing:=$executing_b
	
Function _getLastDayNumber($year_l : Integer; $month_l : Integer) : Integer
	
	var $firstDay_d; $lastDay_d : Date
	
	$firstDay_d:=Date:C102(String:C10($year_l)+"/"+String:C10($month_l)+"/01")
	$firstDay_d:=Add to date:C393($firstDay_d; 0; 1; 0)  // The first day of the next month
	$lastDay_d:=Add to date:C393($firstDay_d; 0; 0; -1)  // then go back 1 day
	return Day of:C23($lastDay_d)
	