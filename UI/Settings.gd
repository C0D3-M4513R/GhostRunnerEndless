extends Control
class_name Settings
var anchor_range=get_anchor(MARGIN_BOTTOM)-get_anchor(MARGIN_TOP)
var reset:Button

func _ready():
	reset=Button.new()
	reset.set_action_mode(BaseButton.ACTION_MODE_BUTTON_PRESS)
	reset.connect("pressed",self,"reset")
	reset.set_text("Reset All")
	add_child(reset)
	var playerRoot:="/root/root/Player"
	var val
	val = VariableValue.new("FOV",playerRoot)
	val.sliderMin=1
	val.sliderMax=179
	val.sliderStep=0.1
	addSetting(val)
	val=VariableValue.new("HORIZONTAL_SPEED_WALLRUN",playerRoot)
	val.sliderMax=100
	addSetting(val)
	val=VariableValue.new("HORIZONTAL_SPEED_GROUND",playerRoot)
	val.sliderMax=100
	addSetting(val)
	val=VariableValue.new("JUMP_COUNTER_AFTER_WALLRUN",playerRoot)
	val.sliderMax=100
	addSetting(val)
	val=VariableValue.new("MOUSE_SENSITIVITY",playerRoot)
	val.sliderStep=.1
	val.sliderMax=2
	addSetting(val)
	val = VariableValue.new("GRAVITY",playerRoot)
	val.sliderMin=-100
	val.sliderMax=0
	val.sliderStep=0.1
	addSetting(val)
	val = VariableValue.new("WALLRUN_DEN",playerRoot)
	val.sliderStep=0.1
	val.sliderMax=50
	addSetting(val)
	val = VariableValue.new("WALLRUN_DEN_ON_WALLRUN",playerRoot)
	val.sliderStep=0.1
	val.sliderMax=50
	addSetting(val)
	val = VariableValue.new("WALLRUN_VELY_DEN_ENTER",playerRoot)
	val.sliderStep=0.1
	val.sliderMax=50
	addSetting(val)
	val = BooleanValue.new("WALLRUN_VELY_DEN_ENTER_ONLY_NEG",playerRoot)
	addSetting(val)
	val = VariableValue.new("MAX_SPEED",playerRoot)
	val.sliderMax=100
	addSetting(val)
	val = VariableValue.new("JUMP_SPEED",playerRoot)
	val.sliderMax=100
	addSetting(val)
	val = VariableValue.new("ACCEL",playerRoot)
	val.sliderMax=100
	addSetting(val)
	val = VariableValue.new("DEACCEL",playerRoot)
	val.sliderMax=100
	addSetting(val)
	val = BooleanValue.new("TILT_ON_WALLRUN",playerRoot+"/Wallrun")
	addSetting(val)
	

func addSetting(node:SettingNode)->void:
	node.set_visible(true)
	node.show()
	add_child(node)
	updateChildren()

func updateChildren()->void:
	var childCount:int= get_child_count()
	for node in get_children():
			var childIndex:int= node.get_index()
			node.set_anchor_and_margin(MARGIN_TOP,0,600.0*childIndex/childCount)
			node.set_anchor_and_margin(MARGIN_LEFT,0,0)
			node.set_anchor_and_margin(MARGIN_RIGHT,1,0)
			node.set_anchor_and_margin(MARGIN_BOTTOM,0,600.0*childIndex/childCount)
			
func resetUI():
	for node in get_children():
		if node is SettingNode:
			node.resetUI()

