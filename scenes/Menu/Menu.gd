extends CanvasLayer



# Refrences
onready var Content := get_node("Content")



# Core
func _ready():
	Content.visible = false


func _process(delta):
	if Input.is_action_just_released("ui_cancel"):
		close() if $Content.visible else open()


func open() -> void:
	Content.visible = true
	get_tree().paused = true

func close() -> void:
	Content.visible = false
	get_tree().paused = false


func _on_Background_gui_input(event):
	if event is InputEventMouseButton:
		close()

func _on_Retire_pressed():
	get_node("/root/Session")._save()
	get_tree().change_scene("res://scenes/Start/Start.tscn")
