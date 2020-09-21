extends KinematicBody2D



# Refrences
onready var AnimationsHead := get_node("AnimationPlayerHead")
onready var AnimationsBody := get_node("AnimationPlayerBody")
onready var TweenRef := get_node("Tween")



# Declarations
signal crashed
signal exited

export(float, 0.0, 100.0) var Stamina := 100.0 setget set_stamina
func set_stamina(stamina : float) -> void:
	Stamina = clamp(stamina, 0.0, 100.0)
export(float, 0.0, 100.0) var StaminaRegen := 1

export(float, 0.0, 1000.0) var Speed := 300.0

export(float, 0.0, 10.0) var Boost := 0.75
export(float, 0.0, 10.0) var BoostCost := 3

export(bool) var PowerActive := false
enum Powers { Dash, Invincible, Attract }
export(Powers) var Power := Powers.Dash
export(float, 0.0, 100.0) var PowerCost := 25.0



# Core
func _ready():
	Speed += get_node("/root/Session").get_upgrade_boost("speed")


func _physics_process(delta : float):
	set_stamina(Stamina + StaminaRegen * delta)
	
	var direction : Vector2
	if Input.is_action_pressed("ui_right"): direction += Vector2.RIGHT
	if Input.is_action_pressed("ui_down"):
		direction += Vector2.DOWN
	if Input.is_action_pressed("ui_left"): direction += Vector2.LEFT
	if Input.is_action_pressed("ui_up"):
		direction += Vector2.UP
	var velocity := direction.normalized() * Speed
	if Input.is_action_pressed("action_boost") and Stamina >= BoostCost:
		Stamina -= BoostCost * delta
		velocity += velocity * Boost
	
	if Input.is_action_just_pressed("action_activate") and not PowerActive and Stamina >= PowerCost:
		PowerActive = true
		Stamina -= PowerCost
		match Power:
			Powers.Dash:
				var destination := Vector2(
					position.x,
					position.y + 45
				)
				destination.y = clamp(destination.y, 9.0, 64.0)
				TweenRef.interpolate_property(
					self,
					"position",
					position,
					destination,
					0.1
				)
				TweenRef.start()
			Powers.Invincible:
				pass
			Powers.Attract:
				pass
	
	if direction.x < 0:
		AnimationsHead.play("left")
	elif direction.x > 0:
		AnimationsHead.play("right")
	else:
		AnimationsHead.play("straight")
	
	var hit := move_and_collide(velocity * delta)
	
	if is_instance_valid(hit):
		if hit.collider.is_in_group("pickable"):
			hit.collider.pick()
		elif hit.collider.is_in_group("ends"):
			emit_signal("exited")
		else:
			emit_signal("crashed")


func _on_Tween_tween_completed(object, key):
	PowerActive = false
