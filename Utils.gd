extends Node
static func variantParser(val)->String:
	match typeof(val):
		TYPE_NIL:
			return "null"
		TYPE_BOOL:
			return "bool"
		TYPE_INT:
			return "int"
		TYPE_REAL:#float
			return "float"
		TYPE_STRING:
			return "String"
		TYPE_VECTOR2:
			return "Vector2"
		TYPE_RECT2:
			return "Rect2"
		TYPE_VECTOR3:
			return "Vector3"
		TYPE_TRANSFORM2D:
			return "Transform2D"
		TYPE_PLANE:
			return "Plane"
		TYPE_QUAT:
			return "Quat"
		TYPE_AABB:
			return "AABB"
		TYPE_BASIS:
			return "Basis"
		TYPE_TRANSFORM:
			return "Transform"
		TYPE_COLOR:
			return "Color"
		TYPE_NODE_PATH:
			return "NodePath"
		TYPE_RID:
			return "RID"
		TYPE_OBJECT:
			return "Object"
		TYPE_DICTIONARY:
			return "Dictionary"
		TYPE_ARRAY:
			return "Array"
		TYPE_RAW_ARRAY:
			return "PoolByteArray"
		TYPE_INT_ARRAY:
			return "PoolIntArray"
		TYPE_REAL_ARRAY:
			return "PoolRealArray"
		TYPE_STRING_ARRAY:
			return "PoolStringArray"
		TYPE_VECTOR2_ARRAY:
			return "PoolVector2Array"
		TYPE_VECTOR3_ARRAY:
			return "PoolVector3Array"
		TYPE_COLOR_ARRAY:
			return "PoolColorArray"
		TYPE_MAX:
			printerr("For some reason Variant was TYPE_MAX.\n Calls depending on this function's return value WILL FAIL!")
			push_warning("TYPE_MAX found as Variant Type")
			print_stack()
			assert (false)
			return ""
		_:
			#This should only run, if the type of val is for some reason Type_Max
			printerr(
"""This Should NEVER appear. If it does, it means, that you are using a newer version of Godot than 3.2.3, or that the dev or Godot has done something wrong.
If you see this, report it immeadiately to the devs of the Game. They should know, if it is a valid concern.
This is a critical error, because we do NOT know, what additional Types there could be hiding here.""")
			push_error("Unknown Variant Type: "+str(typeof(val)))
			print_stack()
			assert (false)
			return ""
