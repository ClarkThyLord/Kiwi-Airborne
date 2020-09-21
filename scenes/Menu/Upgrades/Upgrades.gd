extends VBoxContainer



# Imports
const Upgrade := preload("res://scenes/Menu/Upgrades/Upgrade/Upgrade.tscn")



# Refrences
onready var Feathers := get_node("HBoxContainer/Feathers")

onready var UpgradesRef := get_node("ScrollContainer/Upgrades")
onready var ShowMore := get_node("ScrollContainer/Upgrades/ShowMore")



# Declarations
const Upgrades := [
	{
		"name": "speed",
		"highscore": 25,
		"costs": [ 10, 25, 25, 30, 30, 50, 100 ],
		"boosts": [ 25.0, 25.0, 25.0, 25.0, 50.0, 50.0 ]
	},
	{
		"name": "speed_max",
		"highscore": 25,
		"costs": [ 10, 25, 25, 30, 30, 75, 125 ],
		"boosts": [ 25.0, 10.0, 10.0, 5.0, 15.0, 15.0 ]
	},
	{
		"name": "damage_reduction",
		"highscore": 100,
		"costs": [ 15, 25, 25, 50, 100 ],
		"boosts": [ 0.1, 0.05, 0.05, 0.05, 0.1 ]
	},
	{
		"name": "health_regeneration",
		"highscore": 300,
		"costs": [ 40, 40, 50, 75, 100 ],
		"boosts": [ 0.1, 0.1, 0.1, 0.1, 0.1 ]
	},
	{
		"name": "stamina_regeneration",
		"highscore": 150,
		"costs": [ 20, 20, 25, 65, 100 ],
		"boosts": [ 0.1, 0.1, 0.1, 0.2, 1.0 ]
	},
	{
		"name": "starting_speed",
		"highscore": 25,
		"costs": [ 10, 25, 25, 30, 30, 75, 125 ],
		"boosts": [ 10.0, 10.0, 10.0, 15.0, 15.0, 15.0 ]
	},
	{
		"name": "gravity",
		"highscore": 100,
		"costs": [ 10, 25, 25, 30, 30, 75, 125 ],
		"boosts": [ 25.0, 10.0, 10.0, 5.0, 15.0, 15.0 ]
	},
	{
		"name": "luck",
		"highscore": 500,
		"costs": [ 35, 40, 45, 50, 100, ],
		"boosts": [ 0.1, 0.1, 0.1, 0.2, 0.5 ]
	}
]



# Core
func _ready() -> void: _update()

func _update() -> void:
	Feathers.text = str(get_node("/root/Session").Feathers)
	UpgradesRef.remove_child(ShowMore)
	for child in UpgradesRef.get_children():
		UpgradesRef.remove_child(child)
		child.queue_free()
	
	for upgrade in Upgrades:
		if get_node("/root/Session").Highscore >= upgrade["highscore"]:
			var upgrade_ref := Upgrade.instance()
			upgrade_ref.Info = upgrade
			UpgradesRef.add_child(upgrade_ref)
			upgrade_ref.connect("bought", self, "_update")
	UpgradesRef.add_child(ShowMore)
