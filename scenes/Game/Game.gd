extends Node2D



# Imports
const Rock := preload("res://objects/rock/Rock.tscn")



# Refrences
onready var Kiwi := get_node("Kiwi")

onready var Stats := get_node("CanvasLayer/HUD/Stats")



# Declarations
export(float, 0.0, 250.0) var Speed := 36.0
export(float, 0.0, 100.0) var Gravity := 9.8
export(float, 0.0, 1000.0) var Flight := 0.0


var Spawns = [Vector2(120, 750), Vector2(904, 750)]



# Core
func _process(delta : float) -> void:
	$Background/Mountains.region_rect.position.y += (Speed / 1000) * delta
	$Walls/Texture.region_rect.position.y += Speed * delta
	
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
		object.position.y -= Speed * 6 * delta
	
	Flight += (Speed / 15) * delta
	Speed = clamp(Speed + Gravity * delta, 0.0, 120)
	
	Stats.text = PoolStringArray([
		"FEATHERS : " + str(0) + "\n",
		"FLIGHT : " + str(int(Flight)) + " M\n",
		"SPEED : " + str(int(Speed)) + " \\ " + str(120)
	]).join("")
