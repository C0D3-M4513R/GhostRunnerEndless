class_name Player extends KinematicBody

var wallrunOrInAir :bool = false
const GRAVITY:float = -24.8*2
var vel := Vector3()
const MAX_SPEED:int = 16
const JUMP_SPEED :int= 16
const ACCEL :int= 4

const WALLRUN_HORIZONTAL_SPEED :int=100
const HORIZONTAL_SPEED_GROUND :int =1
var walkingSpeed:int = 1

const JUMP_COUNTER_AFTER_WALLRUN:int=1
var jump_counter:int=0

var wallrun_processor:Wallrun
const WALLRUN_DEN:float = 2.0

var dir := Vector3()

const DEACCEL:int = 16
const MAX_SLOPE_ANGLE:int = 40

var camera:Camera
var rotation_helperx:Spatial
var rotation_helperz:Spatial
var respawnAnchor:Spatial
var jumpCounter:Label
var wallrunOrInAirLabel:Label

var MOUSE_SENSITIVITY:float = 0.1

func _ready()->void:
	camera = $Rotation_Helper_X/Rotation_Helper_Z/Camera
	rotation_helperx = $Rotation_Helper_X
	rotation_helperz = $Rotation_Helper_X/Rotation_Helper_Z
	respawnAnchor = get_node("../RespawnPoint")
	jumpCounter=get_node("../UI/jumpCounter")
	wallrunOrInAirLabel=get_node("../UI/wallrunOrAir")

	wallrun_processor=Wallrun.new()
	wallrun_processor.set_func_is_on_wall(funcref(self,"is_only_on_wall"))
	wallrun_processor.set_func_rotatez(funcref(rotation_helperz,"rotate_z"))
	wallrun_processor.setCallbackOnWallrunLeave(funcref(self,"_WallrunLeaveCallback"))
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func is_only_on_wall()->bool:
	return is_on_wall() and !is_on_floor()

func _get_angle_dir()->int:
	return 0

func _WallrunLeaveCallback():
	jump_counter=JUMP_COUNTER_AFTER_WALLRUN

func _physics_process(delta):
	updateUI()
	process_input(delta)
	process_movement(delta)

func updateUI():
	jumpCounter.set_text("Jump Counter: " +str(jump_counter))
	wallrunOrInAirLabel.set_text("Wallrun or in Air: " +str(wallrunOrInAir))
	
func process_input(delta):
	#This is a crude respawn-machanic, but as a concept, it will work for now, because I want to concentrate on the important bits.
	if self.get_translation().y<-50 or Input.is_action_just_pressed("respawn"):
		reset()
	if wallrun_processor.is_Wallrun(0):
		jump_counter=JUMP_COUNTER_AFTER_WALLRUN
		
	
		# ----------------------------------
	if is_on_floor():
		jump_counter=1
	
	
	wallrun_processor.apply_wallrun()
	if is_on_floor():
		wallrunOrInAir=false
	elif wallrun_processor.is_Wallrun(0):
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
		walkingSpeed = WALLRUN_HORIZONTAL_SPEED
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


	# ----------------------------------
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# ----------------------------------

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()
	
	#This piece of code is there to slow things down, if the Player is Wallrunning,
	# so the Player actually gets something from wallrunning
	var grav:float=delta * GRAVITY 
	if wallrunOrInAir:
		grav/=WALLRUN_DEN

	vel.y+=grav
	
	var hvel := vel
	hvel.y = 0

	var target := dir
	target *= MAX_SPEED

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
