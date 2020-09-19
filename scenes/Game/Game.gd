extends Node2D



# Imports
const Rock := preload("res://objects/rock/Rock.tscn")



# Refrences



# Declarations
var Spawns = [Vector2(120, 750), Vector2(904, 750)]



# Core
func _process(delta : float) -> void:
	$Walls/Texture.region_rect.position.y += 1
	$Background/Mountains.region_rect.position.y += 0.01
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
		object.position.y -= 8
