//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($year_l : Integer; $month_l : Integer)->$lastDayNum_l : Integer

var $firstDay_d; $lastDay_d : Date

$firstDay_d:=Date:C102(String:C10($year_l)+"/"+String:C10($month_l)+"/01")
$firstDay_d:=Add to date:C393($firstDay_d; 0; 1; 0)  // The first day of the next month
$lastDay_d:=Add to date:C393($firstDay_d; 0; 0; -1)  // then go back 1 day

$lastDayNum_l:=Day of:C23($lastDay_d)
