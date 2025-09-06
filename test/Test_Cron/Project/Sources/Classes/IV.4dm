property _winRef : Integer

shared singleton Class constructor
	
shared Function get winRef() : Integer
	
	return This:C1470._winRef
	
shared Function set winRef($winRef_l : Integer)
	
	This:C1470._winRef:=$winRef_l
	
shared Function removeWinRef()
	
	OB REMOVE:C1226(This:C1470; "_winRef")
	