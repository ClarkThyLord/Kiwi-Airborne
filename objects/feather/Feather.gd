tool
extends "res://objects/object.gd"



# Refrences
onready var SpriteRef := get_node("Sprite")



# Core
func _ready():
	image_to_collision_polygon(SpriteRef.texture)


func pick() -> void:
	get_node("/root/Session").Feathers += 1
	.pick()