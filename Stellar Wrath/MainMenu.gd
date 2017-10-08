extends Control

func _ready():
	get_node("StreamPlayer").play(rand_range(13, 15))
	get_node("Help1").hide()
	get_node("Help2").hide()

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_PlayButton_pressed():
	get_tree().change_scene("Space.tscn")
	get_node("StreamPlayer").stop()

func _on_HelpButton_pressed():
	get_node("Help1").show()

func _on_QuitHelpButton_pressed():
	get_node("Help1").hide()
	get_node("Help2").hide()


func _on_NextHelpButton_pressed():
	get_node("Help2").show()
