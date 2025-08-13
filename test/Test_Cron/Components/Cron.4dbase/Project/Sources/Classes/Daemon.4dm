/**
* The Daemon class is used to store daemon prosess information,
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

Class constructor(\
$name_t : Text; \
$function_o : 4D:C1709.Function; \
$interval_v : Variant; \
$parameter_o : Object)
	
/**
* The Daemon class instance object consists of
* name : Text - The name of the daemon process, used to identify among all the other daemons and as worker name
* function : 4D.Function - Function object that will be executed in daemon worker
* interval : Text or Integer - Interval between the next daemon worker is called
* parameter : Object - Parameter to be passed to the function (optional)
*/
	
	ASSERT:C1129(Count parameters:C259>=3; "Lack of parameters")
	ASSERT:C1129(Value type:C1509($name_t)=Is text:K8:3; "The name parameter must be text type")
	ASSERT:C1129($name_t#""; "The name parameter must not be empty string")
	ASSERT:C1129(OB Instance of:C1731($function_o; 4D:C1709.Function); "The function parameter must be instance of 4D.Function")
	ASSERT:C1129((Value type:C1509($interval_v)=Is text:K8:3) | (Value type:C1509($interval_v)=Is longint:K8:6) | (Value type:C1509($interval_v)=Is real:K8:4); "The interval parameter must be text ot numeric type")
	Case of 
		: (Value type:C1509($interval_v)=Is text:K8:3)
			
			ASSERT:C1129(CalcNextLaunchTime($interval_v)#""; "The interval parameter is not correct format")
			
		: ((Value type:C1509($interval_v)=Is longint:K8:6) | (Value type:C1509($interval_v)=Is real:K8:4))
			
			ASSERT:C1129($interval_v#0; "The interval parameter must not be zero")
			
	End case 
	
	This:C1470.name:=$name_t
	This:C1470.function:=$function_o
	This:C1470.interval:=$interval_v
	If (Count parameters:C259>=4)
		This:C1470.parameter:=$parameter_o
	End if 
	
	