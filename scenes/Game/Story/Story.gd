extends Control



# Declarations
onready var Parts := get_node("Parts")
onready var Prompt := get_node("controlsprompt")



# Core
func _ready():
	visible = false
	if get_node("/root/Session").Highscore == 0:
		show_story(1)


var prev_paused : bool
func show_story(part_id : int) -> void:
	visible = true
	prev_paused = get_tree().paused
	get_tree().paused = true
	for part in Parts.get_children():
		part.visible = part.name == str(part_id)

func close() -> void:
	visible = false
	get_tree().paused = prev_paused


func _on_Story_gui_input(event):
	if event is InputEventMouseButton:
		close()


func _on_Timer_timeout():
	Prompt.hide() if Prompt.visible else Prompt.show()
