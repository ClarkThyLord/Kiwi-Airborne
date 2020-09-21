extends ColorRect



# Refrences
onready var NameRef := get_node("VBoxContainer/HBoxContainer/Name")
onready var BoostRef := get_node("VBoxContainer/HBoxContainer/Boost")
onready var Buy := get_node("VBoxContainer/HBoxContainer/Buy")
onready var Levels := get_node("VBoxContainer/Levels")



# Declarations
signal bought

var Info : Dictionary

export(String) var UpgradeName := "" setget set_upgrade_name
func set_upgrade_name(upgrade_name) -> void:
	UpgradeName = upgrade_name
	if is_instance_valid(NameRef):
		NameRef.text = str(UpgradeName).capitalize()

export(float, 0, 100) var Boost := 0.0 setget set_boost
func set_boost(boost : float) -> void:
	Boost = boost
	if is_instance_valid(BoostRef):
		BoostRef.text = str(boost) + "+"

export(int, 0, 10) var Level := 0 setget set_level
func set_level(level : int) -> void:
	Level = level
	if is_instance_valid(Levels):
		Levels.value = Level

export(int, 1, 10) var MaxLevels := 1 setget set_max_level
func set_max_level(max_level : int) -> void:
	MaxLevels = max_level
	if is_instance_valid(Levels):
		Levels.max_value = MaxLevels



# Core
func _ready():
	set_upgrade_name(Info["name"])
	
	set_level(get_node("/root/Session").get_upgrade_level(UpgradeName))
	set_max_level(Info["boosts"].size())
	if Level < MaxLevels:
		set_boost(Info["boosts"][Level])
	
	Buy.text = str(Info["costs"][Level])
	if get_node("/root/Session").Feathers < Info["costs"][Level]:
		Buy.add_color_override("font_color", Color.red)
	Buy.visible = Level < MaxLevels


func _on_Buy_pressed():
	if get_node("/root/Session").Feathers >= Info["costs"][Level]:
		get_node("/root/Session").Feathers -= Info["costs"][Level]
		get_node("/root/Session").set_upgrade(UpgradeName, Info["boosts"][Level], 1)
		get_node("/root/Session")._save()
		emit_signal("bought")
