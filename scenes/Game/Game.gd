extends Node2D



# Imports
const Rock := preload("res://objects/rock/Rock.tscn")



# Refrences
onready var Kiwi := get_node("Kiwi")

onready var Stats := get_node("CanvasLayer/HUD/Stats")



# Declarations
export(float, 0.0, 1000.0) var Flight := 0.0

export(float, 0.0, 100.0) var Gravity := 9.8
export(float, 0.0, 250.0) var FallSpeed := 36.0
export(float, 0.0, 300.0) var FallSpeedMax := 125


var Spawns = [Vector2(120, 750), Vector2(904, 750)]



# Core
func get_max_speed() -> float:
	return FallSpeedMax + get_node("/root/Session").get_boost("max_fall_speed")


func _process(delta : float) -> void:
	$Background/Mountains.region_rect.position.y += (FallSpeed / 1000) * delta
	$Walls/Texture.region_rect.position.y += FallSpeed * delta
	
	if $Objects.get_child_count() < 10:
		var rock = Rock.instance()
		$Objects.add_child(rock)
		randomize()
		rock.Version = randi() % 6
		if randi() % 2 == 0:
			rock.position = Spawns[0]
		else:
			rock.scale.x *= -1
			rock.position = Spawns[1]
	for object in $Objects.get_children():
		object.position.y -= FallSpeed * 6 * delta
	
	Flight += (FallSpeed / 15) * delta
	FallSpeed = clamp(FallSpeed + Gravity * delta, 0.0, get_max_speed())
	
	Stats.text = PoolStringArray([
		"FEATHERS : " + str(get_node("/root/Session").Feathers) + "\n",
		"FLIGHT : " + str(int(Flight)) + " M\n",
		"SPEED : " + str(int(FallSpeed)) + " \\ " + str(get_max_speed())
	]).join("")


func _on_Kiwi_crashed():
	FallSpeed = clamp(FallSpeed - FallSpeed * 0.03, 0.0, get_max_speed())
