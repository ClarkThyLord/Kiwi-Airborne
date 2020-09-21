extends CanvasLayer



# Refrences
onready var Content := get_node("Content")

onready var TabContainerRef := get_node("Content/Control/TextureRect/VBoxContainer/TabContainer")
onready var Upgrades := get_node("Content/Control/TextureRect/VBoxContainer/TabContainer/Upgrades")

onready var Audio := get_node("Content/Control/TextureRect/VBoxContainer/TabContainer/Settings/GridContainer/Audio")
onready var Master := get_node("Content/Control/TextureRect/VBoxContainer/TabContainer/Settings/GridContainer/Master")
onready var Music := get_node("Content/Control/TextureRect/VBoxContainer/TabContainer/Settings/GridContainer/Music")
onready var SoundEffects := get_node("Content/Control/TextureRect/VBoxContainer/TabContainer/Settings/GridContainer/Sound Effects")

onready var Retire := get_node("Content/Control/TextureRect/VBoxContainer/HBoxContainer/Retire")



# Declarations
signal retire

enum TABS { Story, Upgrades, Help, Settings }

export(int) var MinVolume := -40
export(int) var MaxVolume := 45



# Core
func _ready():
	Content.visible = false


func _process(delta):
	if Input.is_action_just_released("ui_cancel"):
		close() if $Content.visible else open()


var paused_before : bool
func open(tab := TABS.Story) -> void:
	TabContainerRef.current_tab = tab
	Content.visible = true
	paused_before = get_tree().paused
	get_tree().paused = true

func close() -> void:
	Content.visible = false
	get_tree().paused = paused_before


func update_settings() -> void:
	Audio.pressed = get_node("/root/Session").Audio
	Master.value = ((AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")) + -MinVolume) / MaxVolume) * 100
	Music.value = ((AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")) + -MinVolume) / MaxVolume) * 100
	SoundEffects.value = ((AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SoundEffects")) + -MinVolume) / MaxVolume) * 100


func _on_Background_gui_input(event):
	if event is InputEventMouseButton:
		close()

func _on_Retire_pressed():
	emit_signal("retire")
	get_tree().change_scene("res://scenes/Start/Start.tscn")


func _on_Restart_pressed():
	get_node("/root/Session")._reset()
	update_settings()


func _on_Content_visibility_changed():
	Retire.visible = not get_tree().get_current_scene().get_name() == "Start"
	update_settings()



func _on_Audio_toggled(button_pressed):
	get_node("/root/Session").Audio = button_pressed
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), !button_pressed)
	get_node("/root/Session")._save()

func _on_Master_value_changed(value):
	value = MinVolume + (MaxVolume * (value * 0.01))
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), value <= MinVolume or not get_node("/root/Session").Audio)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	get_node("/root/Session")._save()

func _on_Music_value_changed(value):
	value = MinVolume + (MaxVolume * (value * 0.01))
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), value <= MinVolume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	get_node("/root/Session")._save()

func _on_Sound_Effects_value_changed(value):
	value = MinVolume + (MaxVolume * (value * 0.01))
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundEffects"), value <= MinVolume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffects"), value)
	get_node("/root/Session")._save()
