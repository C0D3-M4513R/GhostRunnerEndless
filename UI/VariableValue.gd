extends SettingNode
class_name VariableValue 

export var sliderMin := 0
export var sliderMax := 10
export var sliderStep:float= 1

func _init(upropStr:String="",unodeStr:String="").(upropStr,unodeStr):
	pass

func _ready():
	#Create Child objects
	#Create New slider and set it's position
	var slider :=HSlider.new()
	slider.set_anchor_and_margin(MARGIN_LEFT,0,0,true)
	slider.set_anchor_and_margin(MARGIN_TOP,0,16,true)
	slider.set_anchor_and_margin(MARGIN_RIGHT,1,0)
	slider.set_anchor_and_margin(MARGIN_BOTTOM,1,0)

	#Set Slider Defaults
	slider.set_value(getNodeProp())
	slider.set_min(sliderMin)
	slider.set_max(sliderMax)
	slider.set_step(sliderStep)
	slider.set_ticks((sliderMax-sliderMin)/sliderStep+1)
	setAction(slider)
	slider.connect("value_changed",self,"value_changed")

#Note Here the accuracy of the actual change may not be perfect, if you think, that  
func value_changed(value:float)->void:
	setNodeProp(value)
	updateLabel()

func updateAction()->void:
	getAction().set_value(getNodeProp())
