class_name Player extends KinematicBody

const Defaults = preload("res://Defaults.gd")

var FOV:float = Defaults.FOV
var GRAVITY:float = Defaults.GRAVITY
var vel := Vector3()
var MAX_SPEED:int = Defaults.MAX_SPEED
var JUMP_SPEED :int= Defaults.JUMP_SPEED
var ACCEL :int= Defaults.ACCEL
var DEACCEL:int = Defaults.DEACCEL
const MAX_SLOPE_ANGLE:int =Defaults.MAX_SLOPE_ANGLE

#Changabale settings
export var HORIZONTAL_SPEED_WALLRUN :int=Defaults.HORIZONTAL_SPEED_WALLRUN
export var HORIZONTAL_SPEED_GROUND :int =Defaults.HORIZONTAL_SPEED_GROUND

export var JUMP_COUNTER_AFTER_WALLRUN:int = Defaults.JUMP_COUNTER_AFTER_WALLRUN
export var MOUSE_SENSITIVITY:float = Defaults.MOUSE_SENSITIVITY
var WALLRUN_DEN:float = Defaults.WALLRUN_DEN
var WALLRUN_DEN_ON_WALLRUN:float = Defaults.WALLRUN_DEN_ON_WALLRUN
var WALLRUN_VELY_DEN_ENTER:float = Defaults.WALLRUN_VELY_DEN_ENTER
var WALLRUN_VELY_DEN_ENTER_ONLY_NEG:bool = Defaults.WALLRUN_VELY_DEN_ENTER_ONLY_NEG

#No setting
const Wallrun=preload("res://wallrun.gd")
var wallrun_processor:Wallrun


#Dynamically changing
var walkingSpeed:int = 1
var wallrunOrInAir :bool = false
var jump_counter:int=0
var settingsOpen:bool=false



var dir := Vector3()


var camera:Camera
var rotation_helperx:Spatial
var rotation_helperz:Spatial
var respawnAnchor:Spatial
var jumpCounter:Label
var wallrunOrInAirLabel:Label
var settings:Control

func _ready()->void:
	camera = $Rotation_Helper_X/Rotation_Helper_Z/Camera
	rotation_helperx = $Rotation_Helper_X
	rotation_helperz = $Rotation_Helper_X/Rotation_Helper_Z
	respawnAnchor = get_node("/root/root/RespawnPoint")
	jumpCounter=get_node("/root/root/UI/jumpCounter")
	wallrunOrInAirLabel=get_node("/root/root/UI/wallrunOrAir")
	settings=get_node("/root/root/UI/Settings")
	settings.hide()

	wallrun_processor=$Wallrun
	wallrun_processor.set_func_is_on_wall(funcref(self,"is_only_on_wall"))
	wallrun_processor.set_func_rotatez(funcref(rotation_helperz,"rotate_z"))
	wallrun_processor.connect("exit",self,"_WallrunLeave")
	wallrun_processor.connect("enter",self,"_WallrunEnter")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func is_only_on_wall()->bool:
	return is_on_wall() and !is_on_floor()

func _get_angle_dir()->int:
	return 0

func _WallrunLeave():
	jump_counter=JUMP_COUNTER_AFTER_WALLRUN

func _WallrunEnter():
	if !WALLRUN_VELY_DEN_ENTER_ONLY_NEG or vel.y<0:
		vel.y/=WALLRUN_VELY_DEN_ENTER

func _physics_process(delta):
	if FOV != camera.get_fov():
		camera.set_fov(FOV)
	# ----------------------------------
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			settings.hide()
			settingsOpen=false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			settings.show()
			settingsOpen=true
	if settingsOpen:
		return
	updateUI()
	process_input(delta)
	process_movement(delta)

func updateUI():
	jumpCounter.set_text("Jump Counter: " +str(jump_counter))
	wallrunOrInAirLabel.set_text("Wallrun or in Air: " +str(wallrunOrInAir))
	
func process_input(delta):
	# ----------------------------------
	#This is a crude respawn-machanic, but as a concept, it will work for now, because I want to concentrate on the important bits.
	if self.get_translation().y<-50 or Input.is_action_just_pressed("respawn"):
		reset()
	if wallrun_processor.is_Wallrun():
		jump_counter=JUMP_COUNTER_AFTER_WALLRUN
		
	
		# ----------------------------------
	if is_on_floor():
		jump_counter=1
	
	
	wallrun_processor.apply_wallrun()
	if is_on_floor():
		wallrunOrInAir=false
	elif wallrun_processor.is_Wallrun():
		wallrunOrInAir=true
	#else stay, so we get the desired effect, that this var is false, when we jumped from the ground,
	#but true, when we leaped off of a wall
	
	# Jumping
	#NOTE: Unsure, if the extra brackes are needed, but in the docs there is apparently nothing about operator precedence.
	if (is_on_floor() or wallrunOrInAir) and jump_counter>0:
		if Input.is_action_just_pressed("movement_jump"):
			jump_counter-=1
			vel.y = JUMP_SPEED
	# ----------------------------------
	
	
	# ----------------------------------
	# Walking
	if wallrunOrInAir:
		walkingSpeed = HORIZONTAL_SPEED_WALLRUN
	elif is_on_floor():
		walkingSpeed = HORIZONTAL_SPEED_GROUND
	
	dir = Vector3()
	var cam_xform := camera.get_global_transform()

	var input_movement_vector := Vector2()

	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += walkingSpeed
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= walkingSpeed
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x -= walkingSpeed
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x += walkingSpeed
	
	input_movement_vector = input_movement_vector.normalized()
	
	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	# ----------------------------------

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()
	
	#This piece of code is there to slow things down, if the Player is Wallrunning,
	# so the Player actually gets something from wallrunning
	var grav:float=delta * GRAVITY 
	if wallrunOrInAir:
		grav/=WALLRUN_DEN
		if wallrun_processor.is_Wallrun():
			grav/=WALLRUN_DEN_ON_WALLRUN

	vel.y+=grav
	
	var hvel := vel
	hvel.y = 0

	var target := dir
	target *= MAX_SPEED
	if wallrunOrInAir:
		target*=HORIZONTAL_SPEED_WALLRUN

	var accel:int
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helperx.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY* -1))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY* -1))

		var camera_rot = rotation_helperx.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helperx.rotation_degrees = camera_rot
func reset():
	self.set_translation(respawnAnchor.get_translation())
	jump_counter=1
	wallrunOrInAir=false
	vel=Vector3(0,0,0)
	walkingSpeed=HORIZONTAL_SPEED_GROUND
