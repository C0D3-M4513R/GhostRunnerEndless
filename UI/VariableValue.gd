extends Control
class_name VariableValue 


export var playerStr:String="/root/root/Player"
export var propStr:String
var propType:String
export var sliderMin = 0
export var sliderMax = 10
export var sliderStep = 1

var player:Player
var slider:HSlider
var label:Label

const VariantParser=preload("res://Utils.gd")

func _ready():
	player=get_node(playerStr)
	propType=VariantParser.variantParser(player.get(propStr))
	#Create Child objects
	
	#Create a new Label and set it's initial value
	label=Label.new()
	add_child(label)
	label.set_text(propStr + ":%s="%propType +str(player.get(propStr)))
	label.set_anchor_and_margin(MARGIN_TOP,0,0,true)
	label.set_anchor_and_margin(MARGIN_LEFT,0,0,true)
	label.set_anchor_and_margin(MARGIN_RIGHT,anchor_right,margin_right)
	label.set_anchor_and_margin(MARGIN_BOTTOM,16,16)
	
	#Create New slider and set it's position
	slider=HSlider.new()
	add_child(slider)
	slider.set_anchor_and_margin(MARGIN_TOP,0,16,true)
	slider.set_anchor_and_margin(MARGIN_LEFT,0,0,true)
	slider.set_anchor_and_margin(MARGIN_RIGHT,1,0)
	slider.set_anchor_and_margin(MARGIN_BOTTOM,1,0)
	#Set Slider Defaults
	var propVal = player.get(propStr)
	slider.set_value(propVal)
	slider.set_min(sliderMin)
	slider.set_max(sliderMax)
	slider.set_step(sliderStep)
	slider.set_ticks((sliderMax-sliderMin+1)/sliderStep)
	#Connect Actual Var change
	slider.connect("value_changed",self,"value_changed")

#func _draw():
#	draw_circle(Vector2(0,0),1,Color(255,255,255))

#Note Here the accuracy of the actual change may not be perfect, if you think, that  
func value_changed(value:float):
	player.set(propStr,value)
	label.set_text(propStr + ":%s="%propType +str(player.get(propStr)))
