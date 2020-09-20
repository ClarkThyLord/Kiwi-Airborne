tool
extends Node



# Declarations
const VERSION := "0.0.0"
var Plays := 0
var Feathers := 0
var Upgrades := {
	
}



# Core
func _save() -> void:
	var save = File.new()
	var opened = save.open("user://save_data.save", File.WRITE)
	if opened == OK:
		save.store_string(JSON.print({
			"version": VERSION,
			
			"plays": Plays,
			"feathers": Feathers,
			"upgrades": Upgrades
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
	
	if save_data.get("version", "") == VERSION:
		Plays = save_data["plays"]
		Feathers = save_data["feathers"]
		Upgrades = save_data["upgrades"]
	else: _reset()

func _reset() -> void:
	Feathers = 0
	Upgrades.clear()
	_save()


func _ready() -> void: _load()
