//%attributes = {}
var $intervals_c : Collection
var $currentValue_t : Text
var $index_l : Integer
var $logSel_o : cs:C1710.LogSelection

$currentValue_t:=Form:C1466.intervalList.currentValue

$logSel_o:=ds:C1482.Log.all()
$intervals_c:=$logSel_o.distinct("interval")
$intervals_c.insert(0; "all")
$index_l:=$intervals_c.indexOf($currentValue_t)

Form:C1466.intervalList:=Form:C1466.intervalList || {}
Form:C1466.intervalList.values:=$intervals_c
Form:C1466.intervalList.index:=$index_l
Form:C1466.intervalList.currentValue:=$currentValue_t
