extends CanvasLayer



# Refrences
onready var Content := get_node("Content")

onready var TabContainerRef := get_node("Content/Control/TextureRect/VBoxContainer/TabContainer")
onready var Upgrades := get_node("Content/Control/TextureRect/VBoxContainer/TabContainer/Upgrades")

onready var Retire := get_node("Content/Control/TextureRect/VBoxContainer/HBoxContainer/Retire")



# Declarations
signal retire


enum TABS { Upgrades, Help, Settings }



# Core
func _ready():
	Content.visible = false


func _process(delta):
	if Input.is_action_just_released("ui_cancel"):
		close() if $Content.visible else open()


func open(tab := TABS.Upgrades) -> void:
	TabContainerRef.current_tab = tab
	Content.visible = true
	get_tree().paused = true

func close() -> void:
	Content.visible = false
	get_tree().paused = false


func _on_Background_gui_input(event):
	if event is InputEventMouseButton:
		close()

func _on_Retire_pressed():
	emit_signal("retire")
	get_tree().change_scene("res://scenes/Start/Start.tscn")


func _on_Restart_pressed():
	get_node("/root/Session")._reset()


func _on_Content_visibility_changed():
	Retire.visible = not get_tree().get_current_scene().get_name() == "Start"
