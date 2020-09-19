extends KinematicBody2D



# Declarations
export(int) var Height := 0

export(float) var Speed := 150.0 # For horizontal movement 

export(float) var FallSpeed := 10.0 # For vertical movement
export(float) var MaxFallSpeed := 150.0 # Max vertical speed
export(float) var Gravity := 9.8 # Vertical acceleration



# Core
func _ready():
	update()

func _physics_process(delta : float):
	var direction : Vector2
	if Input.is_action_pressed("ui_right"): direction += Vector2.RIGHT
	if Input.is_action_pressed("ui_left"): direction += Vector2.LEFT
#	translate(direction * Speed * delta)
	move_and_collide(direction * Speed * delta)

func _draw():
	draw_circle(Vector2.ZERO, 32, Color.green)
