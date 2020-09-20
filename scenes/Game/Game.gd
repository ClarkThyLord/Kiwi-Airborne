extends Node2D



# Imports
const Feather := preload("res://objects/feather/Feather.tscn")
const Rock := preload("res://objects/rock/Rock.tscn")



# Refrences

onready var WalkingStage := get_node("WalkingStage")
onready var WalkingAnimationPlayer := get_node("WalkingStage/AnimationPlayer")
onready var JumpingGauge := get_node("WalkingStage/Gauge")

onready var FlyingStage := get_node("FlyingStage")
onready var FlyingAnimationPlayer := get_node("FlyingStage/AnimationPlayer")
onready var Kiwi := get_node("FlyingStage/Kiwi")
onready var Objects := get_node("FlyingStage/Objects")

onready var Controls := get_node("CanvasLayer/Controls")
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
			WalkingStage.visible = true
			if not WalkingStage.is_inside_tree():
				add_child(WalkingStage)
			Controls.visible = get_node("/root/Session").Highscore == 0
			JumpingGauge.Active = not Controls.visible
			remove_child(FlyingStage)
		if Stage == Stages.Flying:
			FlyingStage.visible = true
			if not FlyingStage.is_inside_tree():
				add_child(FlyingStage)
			FlyingAnimationPlayer.play("start")
			remove_child(WalkingStage)
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
	get_node("/root/Menu").connect("retire", self, "summary")


func get_max_speed() -> float:
	return FallSpeedMax + get_node("/root/Session").get_boost("max_fall_speed")


func summary() -> void:
	if get_node("/root/Session").Highscore < Flight:
		get_node("/root/Session").Highscore = Flight
	get_node("/root/Session")._save()


func _process(delta : float) -> void:
	match Stage:
		Stages.Walking:
			pass
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
			$FlyingStage/Walls/Texture.region_rect.position.y += FallSpeed * delta
			for object in Objects.get_children():
				object.position.y -= FallSpeed * delta
			
			
			Flight += (FallSpeed / 15) * delta
			FallSpeed = clamp(FallSpeed + Gravity * delta, 0.0, get_max_speed())
			
			Feathers.text = str(get_node("/root/Session").Feathers)
			Stats.text = PoolStringArray([
				"FLIGHT : " + str(int(Flight)) + " M\n",
				("HIGHSCORE :\n" + str(int(get_node("/root/Session").Highscore)) + " M\n") if get_node("/root/Session").Highscore > 0 else "",
				"SPEED : " + str(int(FallSpeed)) + " \\ " + str(get_max_speed())
			]).join("")


# Controls prompt
func _on_Controls_gui_input(event):
	if Controls.visible and event is InputEventMouseButton:
		Controls.hide()
		JumpingGauge.Active = true
		Controls.accept_event()

func _on_Timer_timeout():
	$CanvasLayer/Controls/VBoxContainer/Prompt.modulate.a = 0 if $CanvasLayer/Controls/VBoxContainer/Prompt.modulate.a == 1 else 1


# Jump stage
func _on_Gauge_hit(value):
	WalkingAnimationPlayer.play("jump")


# Flying stage
func _on_Kiwi_crashed():
	FallSpeed = clamp(FallSpeed - FallSpeed * 0.03, 0.0, get_max_speed())

func _on_Kiwi_exited():
	pass # Replace with function body.
