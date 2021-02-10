extends SettingNode
class_name BooleanValue

func _init(upropStr:String="",unodeStr:String="").(upropStr,unodeStr):
	pass

func _ready():
	var check :=CheckBox.new()
	var scale = check.get_scale()
	getLabel().set_anchor_and_margin(MARGIN_BOTTOM,1,0)
	getLabel().set_anchor_and_margin(MARGIN_RIGHT,1,scale.x)
	#Create Child objects
	#Create New slider and set it's position
	
	check.set_anchor_and_margin(MARGIN_LEFT,1,-scale.x,true)
	check.set_anchor_and_margin(MARGIN_TOP,0,0,true)
	check.set_anchor_and_margin(MARGIN_RIGHT,1,0)
	check.set_anchor_and_margin(MARGIN_BOTTOM,1,0)

	#Set Slider Defaults
	check.set_pressed(getNodeProp())
	setAction(check)
	check.connect("toggled",self,"toggled")

#Note Here the accuracy of the actual change may not be perfect, if you think, that  
func toggled(pressed:bool):
	setNodeProp(pressed)
	updateLabel()

func updateAction()->void:
	getAction().set_pressed(getNodeProp())
