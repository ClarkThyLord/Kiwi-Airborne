extends Node2D



# Imports
const Feather := preload("res://objects/feather/Feather.tscn")
const Rock := preload("res://objects/rock/Rock.tscn")



# Refrences
onready var Kiwi := get_node("Kiwi")

onready var Feathers := get_node("CanvasLayer/HUD/VBoxContainer/Feathers")
onready var Stats := get_node("CanvasLayer/HUD/VBoxContainer/Stats")



# Declarations
export(float, 0.0, 1000.0) var Flight := 0.0

export(float, 0.0, 100.0) var Gravity := 9.8
export(float, 0.0, 250.0) var FallSpeed := 36.0
export(float, 0.0, 300.0) var FallSpeedMax := 125

export(float, 0.0, 1.0) var Luck := 0.3


var Spawns = [Vector2(120, 750), Vector2(904, 750)]



# Core
func _ready(): randomize()


func get_max_speed() -> float:
	return FallSpeedMax + get_node("/root/Session").get_boost("max_fall_speed")


func _process(delta : float) -> void:
	if $Objects.get_child_count() < 10:
		var rock = Rock.instance()
		$Objects.add_child(rock)
		rock.Version = randi() % 6
		if randi() % 2 == 0:
			rock.position = Spawns[0]
		else:
			rock.scale.x *= -1
			rock.position = Spawns[1]
	
	if randf() < Luck:
		var feather = Feather.instance()
		$Objects.add_child(feather)
		feather.position = Spawns[0]
		feather.position.x += 100 + randi() % 400
	
	
	$Background/Mountains.region_rect.position.y += (FallSpeed / 1000) * delta
	$Walls/Texture.region_rect.position.y += FallSpeed * delta
	for object in $Objects.get_children():
		object.position.y -= FallSpeed * 6 * delta
	
	
	Flight += (FallSpeed / 15) * delta
	FallSpeed = clamp(FallSpeed + Gravity * delta, 0.0, get_max_speed())
	
	Feathers.text = str(get_node("/root/Session").Feathers)
	Stats.text = PoolStringArray([
		"FLIGHT : " + str(int(Flight)) + " M\n",
		"SPEED : " + str(int(FallSpeed)) + " \\ " + str(get_max_speed())
	]).join("")


func _on_Kiwi_crashed():
	FallSpeed = clamp(FallSpeed - FallSpeed * 0.03, 0.0, get_max_speed())
