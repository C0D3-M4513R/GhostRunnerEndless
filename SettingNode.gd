extends Control
class_name SettingNode

export var nodeStr:String="/root/root/Player"
export var propStr:String
var propType:String setget updateType,getPropType

var node:Node
var action setget setAction,getAction
var label:Label setget ,getLabel
const VariantParser=preload("res://Utils.gd")
var initFinished:bool=false

func _init(upropStr:String="",unodeStr:String=""):
	if unodeStr!="":
		nodeStr=unodeStr
	if upropStr!="":
		propStr=upropStr

func _ready():
	node=get_node(nodeStr)
	updateType()
	#Create a new Label and set it's initial value
	label=Label.new()
	add_child(label)
	label.set_visible(true)
	label.show()
	label.set_anchor_and_margin(MARGIN_LEFT,0,0,true)
	label.set_anchor_and_margin(MARGIN_TOP,0,0,true)
	label.set_anchor_and_margin(MARGIN_RIGHT,1,0)
	label.set_anchor_and_margin(MARGIN_BOTTOM,0,0.25*get_margin(MARGIN_BOTTOM)-get_margin(MARGIN_TOP))
	updateLabel()

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
func getLabel()->Label:
	return label
func getPropType()->String:
	return propType
func updateType(u=0)->void:
	propType=VariantParser.variantParser(getNodeProp())
func updateLabel()->void:
	label.set_text(propStr + ":%s="%getPropType() +str(getNodeProp()))
