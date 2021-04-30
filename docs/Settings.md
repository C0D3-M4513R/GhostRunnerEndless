# Settings
Settins name | Type | Default Value | Description
--------|:------:|:-------|:--------------
FOV|float|100.0|Camera Field Of View
GRAVITY|float|-24.8*2| How much are you pulled down
WALLRUN_DEN|float|2.0| How much less Gravity do you have in Air, when "wallrunOrInAir" is true
WALLRUN_DEN_ON_WALLRUN|float|2.0| The same as WALLRUN_DEN, but this is only, if you are actually in a  Wallrun(Screen is tilted, also see "TILT_ON_WALLRUN")
WALLRUN_VELY_DEN_ENTER|float|4.0| How much Y Velocity should get taken away, once you enter a Wallrun(Screen is tilted, also see "TILT_ON_WALLRUN")
WALLRUN_VELY_DEN_ENTER_ONLY_NEG|bool|true| This determines, if "WALLRUN_VELY_DEN_ENTER" should only be applied, if you are going down(y Velocity is negative)
TILT_ON_WALLRUN|bool|true| Should the Screen be tilted, if you are in a Wallrun?
MAX_SPEED|int|16|Base speed
JUMP_SPEED|int|40|How much speed should a single Jump get. Applies if one Jumps from the Ground.
JUMP_SPEED_WALLRUN|int|30|How much speed should a single Jump get. Applies, if wallrunOrInAir is true.
JUMP_COUNTER_AFTER_WALLRUN|int|2
ACCEL|int|4|If the Vertical Velocity is non-Negative, this determines, how quickly one is accelerated to the "JUMP_SPEED"
DEACCEL|int|16|If the Vertical Velocity is Negative, this determines, how quickly the downwards momentum gets cancelled.
HORIZONTAL_SPEED_WALLRUN|int|2|Horizontal base speed multiplier. This gets used, when "wallrunOrInAir" is true
HORIZONTAL_SPEED_GROUND|int|1|Horizontal base speed multiplier. This gets used, when one is on a Ground
MOUSE_SENSITIVITY|float|0.1| Mouse Sensitivity. How much does the Camera move, per mouse movement

## Changing Variables
Name|Type|Description
----|:-:|:----------
wallrunOrInAir|bool|Is set to true, is one is entering a Wallrun, and is only set to false, when one touches the Ground. In the Air, it's state is defined, on what surface, someone jumped from. If it was a Wall, it is true. If you Jumped from the Floor, this is false.
