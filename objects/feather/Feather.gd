tool
extends "res://objects/object.gd"



# Refrences
onready var SpriteRef := get_node("Sprite")
onready var PickAudio := get_node("AudioStreamPlayer")


# Declarations
export(bool) var Picked := false


# Core
func _ready():
	image_to_collision_polygon(SpriteRef.texture)


func pick() -> void:
	if not Picked:
		get_node("/root/Session").Feathers += 1
		PickAudio.play()
		visible = false
		CollisionPolygon2DRef.disabled = true


func _on_AudioStreamPlayer_finished():
	queue_free()
