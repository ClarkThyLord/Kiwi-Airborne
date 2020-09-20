extends Control



# Core
func _on_Play_pressed():
	get_tree().change_scene("res://scenes/Game/Game.tscn")

func _on_Help_pressed():
	get_node("/root/Menu").open(get_node("/root/Menu").TABS.Help)

func _on_Settings_pressed():
	get_node("/root/Menu").open(get_node("/root/Menu").TABS.Settings)
