extends KinematicBody2D



# Refrences



# Declarations
signal crashed
signal stopped

export(float) var Speed := 300.0 # For horizontal movement



# Core
func _physics_process(delta : float):
	var direction : Vector2
	if Input.is_action_pressed("ui_right"): direction += Vector2.RIGHT
	if Input.is_action_pressed("ui_down") and position.y < 500:
		direction += Vector2.DOWN
	if Input.is_action_pressed("ui_left"): direction += Vector2.LEFT
	if Input.is_action_pressed("ui_up") and position.y > 100:
		direction += Vector2.UP
	var hit = move_and_collide(direction.normalized() * Speed * delta)
	
	if is_instance_valid(hit):
		print("crashed")
		emit_signal("crashed")
