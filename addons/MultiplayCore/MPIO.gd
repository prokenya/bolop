@icon("res://addons/MultiplayCore/icons/MultiPlayIO.svg")
extends MPBase
## Input/Output Singleton for MultiPlay

class_name MultiPlayIO

signal mpc_ready

## Main MultiPlay Core
var mpc: MultiPlayCore = null:
	set(value):
		mpc = value
		if mpc:
			mpc_ready.emit()
	get():
		return mpc
var plr_id: int = 0

## Log data to the output console
func logdata(data):
	var roles = ""
	
	roles = roles + "[" + str(plr_id) + "] "
	
	print_rich(roles + str(data))

## Log warning to the output console
func logwarn(data):
	logdata("[[color=yellow]WARN[/color]] " + str(data))

## Log errpr to the output console
func logerr(data):
	logdata("[[color=red]ERR[/color]] " + str(data))
