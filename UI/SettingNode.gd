extends Control
class_name SettingNode

const Default = preload("res://Defaults.gd")
export var nodeStr:String="/root/root/Player"
export var propStr:String
var propType:String setget updateType,getPropType

var node:Node#node of the setting
var action setget setAction,getAction

var cont:Control setget ,getLabel
var label:Label
var reset:Button

const VariantParser=preload("res://Utils.gd")

func _init(upropStr:String="",unodeStr:String=""):
	if unodeStr!="":
		nodeStr=unodeStr
	if upropStr!="":
		propStr=upropStr

func _ready():
	cont=Control.new()
	cont.set_anchor_and_margin(MARGIN_LEFT,0,0)
	cont.set_anchor_and_margin(MARGIN_TOP,0,0)
	cont.set_anchor_and_margin(MARGIN_RIGHT,.75,0)
	cont.set_anchor_and_margin(MARGIN_BOTTOM,0,0.25*get_margin(MARGIN_BOTTOM)-get_margin(MARGIN_TOP))
	add_child(cont)
	
	
	#allow for resetting the Settings
	reset = Button.new()
	reset.set_anchor_and_margin(MARGIN_LEFT,.75,0,true)
	reset.set_anchor_and_margin(MARGIN_TOP,0,0,true)
	reset.set_anchor_and_margin(MARGIN_RIGHT,1,0)
	reset.set_anchors_and_margins_preset(MARGIN_BOTTOM,1,0)
	reset.set_text("Reset")
	cont.add_child(reset)
	reset.set_action_mode(BaseButton.ACTION_MODE_BUTTON_PRESS)
	reset.set_toggle_mode(false)
	var tmp:= reset.connect("pressed",self,"resetTrigger")
	if tmp != OK:
		printerr("Error: "+str(tmp))
	
	node=get_node(nodeStr)
	updateType()
	
	#Create a new Label and set it's initial value
	label=Label.new()
	label.set_anchor_and_margin(MARGIN_LEFT,0,0,true)
	label.set_anchor_and_margin(MARGIN_TOP,0,0,true)
	label.set_anchor_and_margin(MARGIN_RIGHT,.75,0)
	label.set_anchor_and_margin(MARGIN_BOTTOM,1,0)
	label.set_align(Label.ALIGN_LEFT)
	label.set_valign(Label.VALIGN_CENTER)
	updateLabel()
	cont.add_child(label)

func getNodeProp():
	return node.get(propStr)
func setNodeProp(value)->void:
	node.set(propStr,value)
func setAction(uaction)->void:
	if action:
		remove_child(action)
	action=uaction
	add_child(action)
	action.set_visible(true)
	action.show()
func getAction():
	return action
func getLabel()->Control:
	return cont
func getPropType()->String:
	return propType
func updateType(u=0)->void:
	propType=VariantParser.variantParser(getNodeProp())
func updateLabel()->void:
	label.set_text(propStr + ":%s="%getPropType() +str(getNodeProp()))
func updateAction():
	pass
func resetUI()->void:
	setNodeProp(Default.new().get(propStr))
	updateAction()
	updateLabel()
func resetTrigger()->void:
	resetUI()
	reset.set_pressed(false)
