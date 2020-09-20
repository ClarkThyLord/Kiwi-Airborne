extends KinematicBody2D



# Refrences
onready var AnimationPlayerRef := get_node("AnimationPlayer")



# Declarations
signal crashed
signal stopped

export(float) var Speed := 300.0



# Core
func _ready():
	if not Engine.editor_hint:
		Speed += get_node("/root/Session").get_boost("max_kiwi_speed")


func _physics_process(delta : float):
	var direction : Vector2
	if Input.is_action_pressed("ui_right"): direction += Vector2.RIGHT
	if Input.is_action_pressed("ui_down") and position.y > 0:
		direction += Vector2.DOWN
	if Input.is_action_pressed("ui_left"): direction += Vector2.LEFT
	if Input.is_action_pressed("ui_up") and position.y < 1000:
		direction += Vector2.UP
	if direction.x < 0:
		AnimationPlayerRef.play("left")
	elif direction.x > 0:
		AnimationPlayerRef.play("right")
	var hit := move_and_collide(direction.normalized() * Speed * delta)
	
	if is_instance_valid(hit):
		if hit.collider.is_in_group("ends"):
			emit_signal("stopped")
		elif hit.collider.is_in_group("pickable"):
			hit.collider.pick()
		else:
			emit_signal("crashed")