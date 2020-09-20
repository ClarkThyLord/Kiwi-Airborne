tool
extends Node



# Declarations
const VERSION := "0.0.2"

var Highscore := 0
var Feathers := 0

var Boosts := {}



# Core
func _save() -> void:
	var save = File.new()
	var opened = save.open("user://save_data.save", File.WRITE)
	if opened == OK:
		save.store_string(JSON.print({
			"version": VERSION,
			
			"highscore": Highscore,
			"feathers": Feathers,
			
			"boosts": Boosts
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
		
		Boosts = save_data["boosts"]
	else: _reset()

func _reset() -> void:
	Highscore = 0
	Feathers = 0
	Boosts.clear()
	_save()


func _ready() -> void: _load()


func get_boost(boost : String) -> float:
	return Boosts.get(boost, 0.0)
