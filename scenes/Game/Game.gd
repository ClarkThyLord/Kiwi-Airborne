extends Node2D



# Refrences



# Declarations
var Spawns = [Vector2(150, 750), Vector2(874, 750)]



# Core
func _process(delta : float) -> void:
	$Walls/Texture.region_rect.position.y += 1
	$Background/Mountains.region_rect.position.y += 0.01
