class_name Wallrun

const TIMEOUT:int=25
var timeout:int=0

var isWallrun:bool setget is_Wallrun
export var disableWallrun:bool = false
var is_on_wall:FuncRef setget set_func_is_on_wall
var rotatez:FuncRef setget set_func_rotatez
var WREntry:FuncRef setget setCallbackOnWallrunEntry 
var WRLeave:FuncRef setget setCallbackOnWallrunEntry

const TILT_AMOUNT:int = 30

func _init()->void:
	isWallrun=false
	WREntry=funcref(self,"NOOP")
	WRLeave=WREntry
	
#func _init(is_on_wall:FuncRef,rotatez:FuncRef)->void:
#	_init()
#	rotatez=rotatez
#	is_on_wall=is_on_wall
	
func set_func_rotatez(urotatez) -> void:
	rotatez=urotatez
	return 

func set_func_is_on_wall(uis_on_wall) ->void:
	is_on_wall=uis_on_wall
	return

func is_Wallrun(uWallrun:bool)->bool:
	return isWallrun

func setCallbackOnWallrunEntry(callback):
	WREntry=callback

func setCallbackOnWallrunLeave(callback):
	WRLeave=callback

func NOOP():
	pass
func apply_wallrun()->void:
	if timeout>0:
		timeout-=1
#	if !uapply:
#		return
	#TODO: Make the Wall always rotate down
	var tilt_angle=TILT_AMOUNT
	if is_on_wall.call_func() and !isWallrun and timeout<=0:
		rotatez.call_func(deg2rad(tilt_angle))
		isWallrun=true
		timeout=TIMEOUT
		if WREntry!=null:
			WREntry.call_func()
	elif (!is_on_wall.call_func() and isWallrun) or disableWallrun:
		rotatez.call_func(deg2rad(-tilt_angle))
		isWallrun=false
		disableWallrun=false
		if WRLeave!=null:
			WRLeave.call_func()

