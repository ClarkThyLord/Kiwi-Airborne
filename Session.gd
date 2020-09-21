tool
extends Node



# Declarations
const VERSION := "0.0.4"

var Highscore := 0
var Feathers := 0

var Upgrades := {}

var Audio := true



# Core
func _save() -> void:
	var save = File.new()
	var opened = save.open("user://save_data.save", File.WRITE)
	if opened == OK:
		save.store_string(JSON.print({
			"version": VERSION,
			
			"highscore": Highscore,
			"feathers": Feathers,
			
			"upgrades": Upgrades,
			
			"audio": Audio,
			"master": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")),
			"music": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")),
			"sound_effects": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SoundEffects")),
		}))
		save.close()

func _load() -> void:
	var save_data := {}
	var save = File.new()
	var opened = save.open("user://save_data.save", File.READ)
	if opened == OK:
		var result := JSON.parse(save.get_as_text())
		if result.error == OK and typeof(result.result) == TYPE_DICTIONARY:
			save_data = result.result
		save.close()
	
	if save_data.empty(): return
	if save_data.get("version", "") == VERSION:
		Highscore = save_data["highscore"]
		Feathers = save_data["feathers"]
		
		Upgrades = save_data["upgrades"]
		
		Audio = save_data["audio"]
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), save_data.get("master", 0) <= -40 and not Audio)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), save_data.get("master", 0))
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), save_data.get("music", 0) <= -40)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), save_data.get("music", 0))
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundEffects"), save_data.get("sound_effects", 0) <= -40)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffects"), save_data.get("sound_effects", 0))
	else: _reset()

func _reset() -> void:
	pause_mode = PAUSE_MODE_PROCESS
	Highscore = 0
	Feathers = 0
	Upgrades.clear()
	_save()


func _ready() -> void: _load()


func set_upgrade(upgrade : String, boost : float, level : int) -> void:
	if not Upgrades.has(upgrade):
		Upgrades[upgrade] = {
			"boost": 0.0,
			"level": 0
		}
	Upgrades[upgrade]["boost"] += boost
	Upgrades[upgrade]["level"] += level

func get_upgrade_boost(upgrade : String) -> float:
	return Upgrades.get(upgrade, {}).get("boost", 0.0)

func get_upgrade_level(upgrade : String) -> int:
	return Upgrades.get(upgrade, {}).get("level", 0)
