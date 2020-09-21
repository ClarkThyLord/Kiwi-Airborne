extends VBoxContainer



# Imports
const Upgrade := preload("res://scenes/Menu/Upgrades/Upgrade/Upgrade.tscn")



# Refrences
onready var Feathers := get_node("HBoxContainer/Feathers")
onready var UpgradesRef := get_node("ScrollContainer/Upgrades")



# Declarations
const Upgrades := [
	{
		"name": "speed",
		"costs": [ 10, 25, 25, 30, 30, 50, 100 ],
		"boosts": [ 25.0, 25.0, 25.0, 25.0, 50.0, 50.0 ]
	},
	{
		"name": "speed_max",
		"costs": [ 10, 25, 25, 30, 30, 75, 125 ],
		"boosts": [ 25.0, 10.0, 10.0, 5.0, 15.0, 15.0 ]
	}
]



# Core
func _ready() -> void: _update()

func _update() -> void:
	Feathers.text = str(get_node("/root/Session").Feathers)
	for child in UpgradesRef.get_children():
		UpgradesRef.remove_child(child)
		child.queue_free()
	
	for upgrade in Upgrades:
		var upgrade_ref := Upgrade.instance()
		upgrade_ref.Info = upgrade
		UpgradesRef.add_child(upgrade_ref)
		upgrade_ref.connect("bought", self, "_update")
