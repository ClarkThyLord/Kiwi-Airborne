extends Node2D



# Imports
const Rock := preload("res://objects/rock/Rock.tscn")
const TreeClass := preload("res://objects/tree/Tree.tscn")
const Crystal := preload("res://objects/crystal/Crystal.tscn")

const Feather := preload("res://objects/feather/Feather.tscn")



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
onready var Health := get_node("CanvasLayer/HUD/VBoxContainer/Health")
onready var Stamina := get_node("CanvasLayer/HUD/VBoxContainer/Stamina")
onready var Feathers := get_node("CanvasLayer/HUD/VBoxContainer/Feathers")
onready var Stats := get_node("CanvasLayer/HUD/VBoxContainer/Stats")

onready var SummaryRef := get_node("CanvasLayer/Summary")
onready var SummaryStats := get_node("CanvasLayer/Summary/TextureRect/VBoxContainer/Stats")



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
export(float, 0.0, 300.0) var FallSpeedMax := 125.0

export(float, 0.0, 1.0) var Luck := 0.3
export(int, 0, 100) var MaxObstructions := 10


var Spawns := [Vector2(15, 100), Vector2(119, 100)]



# Core
func _ready():
	get_tree().paused = false
	
	randomize()
	
	Gravity += get_node("/root/Session").get_upgrade_boost("gravity")
	FallSpeed += get_node("/root/Session").get_upgrade_boost("starting_speed")
	FallSpeedMax += get_node("/root/Session").get_upgrade_boost("speed_max")
	Luck = get_node("/root/Session").get_upgrade_boost("luck")
	
	Controls.hide()
	HUD.hide()
	SummaryRef.hide()
	
	set_stage(Stage)
	
	get_node("/root/Menu").connect("retire", self, "summary")


func get_max_speed() -> float:
	return FallSpeedMax


func summary() -> void:
	get_tree().paused = true
	$CanvasLayer/Summary/TextureRect/VBoxContainer/Highscore.visible = get_node("/root/Session").Highscore < Flight
	if get_node("/root/Session").Highscore < Flight:
		get_node("/root/Session").Highscore = Flight
	
	SummaryStats.text = PoolStringArray([
		"FLIGHT   : " + str(int(Flight)) + " M\n",
		"FEATHERS : " + str(get_node("/root/Session").Feathers)
	]).join("")
	
	Controls.hide()
	HUD.hide()
	SummaryRef.show()
	
	get_node("/root/Session")._save()


func _process(delta : float) -> void:
	match Stage:
		Stages.Walking:
			pass
		Stages.Flying:
			if randf() < Luck:
				if randf() < Luck:
					var feather = Feather.instance()
					Objects.add_child(feather)
					feather.position = Spawns[0]
					feather.position.x += Spawns[0].x + randi() % int(Spawns[1].x)
			else:
				while get_tree().get_nodes_in_group("obstruction").size() < MaxObstructions:
					var obstruction
					var chance := 1 # Rocks
					if Flight > 200: chance += 1 # Trees
					if Flight > 450: chance += 1 # Crystals
					match randi() % chance:
						1: obstruction = TreeClass.instance()
						2: obstruction = Crystal.instance()
						_: obstruction = Rock.instance()
					Objects.add_child(obstruction)
					obstruction.Version = randi() % 6
					obstruction.scale = Vector2.ONE * (0.3 + randf())
					if randi() % 2 == 0:
						obstruction.position = Spawns[0]
					else:
						obstruction.scale.x *= -1
						obstruction.position = Spawns[1]
					if randf() < Luck: break
			
			
			$Background/Mountains.region_rect.position.y += (FallSpeed / 750) * delta
			$FlyingStage/Walls/Texture.region_rect.position.y += FallSpeed * delta
			for object in Objects.get_children():
				object.position.y -= FallSpeed * delta
			
			
			if FallSpeed < 20:
				summary()
			
			Flight += (FallSpeed / 15) * delta
			FallSpeed = clamp(FallSpeed + Gravity * delta, 0.0, get_max_speed())
			
			Health.value = Kiwi.Health
			Stamina.value = Kiwi.Stamina
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
	$CanvasLayer/Summary/TextureRect/VBoxContainer/Highscore.modulate.a = 0 if $CanvasLayer/Summary/TextureRect/VBoxContainer/Highscore.modulate.a == 1 else 1


# Jump stage
func _on_Gauge_hit(goal : bool):
	if goal: FallSpeed += FallSpeed * 0.25
	WalkingAnimationPlayer.play("jump_gold" if goal else "jump")


# Flying stage
func _on_Kiwi_hit():
	FallSpeed = clamp(FallSpeed - FallSpeed * 0.03, 0.0, get_max_speed())

func _on_Kiwi_crashed():
	summary()

func _on_Kiwi_exited():
	if Kiwi.Health > 0:
		FlyingAnimationPlayer.play("start")


func _on_Play_pressed():
	get_tree().change_scene("res://scenes/Game/Game.tscn")

func _on_Upgrades_pressed():
	get_node("/root/Menu").open()
