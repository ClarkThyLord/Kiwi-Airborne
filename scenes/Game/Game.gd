extends Node2D



# Imports
const Feather := preload("res://objects/feather/Feather.tscn")
const Rock := preload("res://objects/rock/Rock.tscn")



# Refrences
onready var Walking := get_node("Walking")
onready var JumpingGauge := get_node("Walking/Gauge")
onready var WalkingAnimation := get_node("Walking/AnimationPlayer")

onready var Flying := get_node("Flying")
onready var Kiwi := get_node("Flying/Kiwi")
onready var Objects := get_node("Flying/Objects")

onready var HUD := get_node("CanvasLayer/HUD")
onready var Feathers := get_node("CanvasLayer/HUD/VBoxContainer/Feathers")
onready var Stats := get_node("CanvasLayer/HUD/VBoxContainer/Stats")



# Declarations
enum Stages { Walking, Flying }
export(Stages) var Stage := Stages.Walking setget set_stage
func set_stage(stage : int) -> void:
	Stage = stage
	if is_inside_tree():
		if Stage == Stages.Walking:
			Walking.visible = true
			if not Walking.is_inside_tree():
				add_child(Walking)
			JumpingGauge.Active = true
			remove_child(Flying)
		if Stage == Stages.Flying:
			Flying.visible = true
			if not Flying.is_inside_tree():
				add_child(Flying)
			remove_child(Walking)
		HUD.visible = Stage == Stages.Flying

export(float, 0.0, 1000.0) var Flight := 0.0

export(float, 0.0, 100.0) var Gravity := 9.8
export(float, 0.0, 250.0) var FallSpeed := 36.0
export(float, 0.0, 300.0) var FallSpeedMax := 125

export(float, 0.0, 1.0) var Luck := 0.3


var Spawns = [Vector2(15, 100), Vector2(119, 100)]



# Core
func _ready():
	randomize()
	set_stage(Stage)


func get_max_speed() -> float:
	return FallSpeedMax + get_node("/root/Session").get_boost("max_fall_speed")


func _process(delta : float) -> void:
	match Stage:
		Stages.Walking:
			update()
		Stages.Flying:
			if Objects.get_child_count() < 10:
				var rock = Rock.instance()
				Objects.add_child(rock)
				rock.Version = randi() % 6
				if randi() % 2 == 0:
					rock.position = Spawns[0]
				else:
					rock.scale.x *= -1
					rock.position = Spawns[1]
			
			if randf() < Luck:
				var feather = Feather.instance()
				Objects.add_child(feather)
				feather.position = Spawns[0]
				feather.position.x += Spawns[0].x + randi() % int(Spawns[1].x)
			
			
			$Background/Mountains.region_rect.position.y += (FallSpeed / 1000) * delta
			$Flying/Walls/Texture.region_rect.position.y += FallSpeed * delta
			for object in Objects.get_children():
				object.position.y -= FallSpeed * delta
			
			
			Flight += (FallSpeed / 15) * delta
			FallSpeed = clamp(FallSpeed + Gravity * delta, 0.0, get_max_speed())
			
			Feathers.text = str(get_node("/root/Session").Feathers)
			Stats.text = PoolStringArray([
				"FLIGHT : " + str(int(Flight)) + " M\n",
				"SPEED : " + str(int(FallSpeed)) + " \\ " + str(get_max_speed())
			]).join("")


func _draw():
	draw_rect(Rect2(Vector2(), Vector2(800, 600)), Color.blue)


func _on_Kiwi_crashed():
	FallSpeed = clamp(FallSpeed - FallSpeed * 0.03, 0.0, get_max_speed())


func _on_Gauge_hit(value):
	WalkingAnimation.play("jump")
