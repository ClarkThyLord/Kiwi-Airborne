extends TabContainer



# Core
func _on_Story_visibility_changed():
	set_tab_disabled(1, get_node("/root/Session").Highscore < 200)
	set_tab_disabled(2, get_node("/root/Session").Highscore < 450)
	set_tab_disabled(3, get_node("/root/Session").Highscore < 1000)
	
	var current := 0
	if get_node("/root/Session").Highscore >= 1000: current = 3
	elif get_node("/root/Session").Highscore >= 450: current = 2
	elif get_node("/root/Session").Highscore >= 200: current = 1
	current_tab = current
