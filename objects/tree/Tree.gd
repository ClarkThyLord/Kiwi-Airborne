tool
extends "res://objects/object.gd"



# Refrences
onready var SpriteRef := get_node("Sprite")



# Declarations
export(int, 0, 5) var Version := 0 setget set_version
func set_version(version : int) -> void:
	Version = int(clamp(version, 0, 5))
	if is_instance_valid(SpriteRef):
		SpriteRef.texture = load("res://assets/objects/trees/" + str(version + 1) + ".png")
		image_to_collision_polygon(SpriteRef.texture)



# Core
func _ready():
	set_version(Version)
