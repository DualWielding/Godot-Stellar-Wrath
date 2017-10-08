extends Control

func _ready():
	hide_submit()
	hide_title()

func show_submit():
	get_node("SubmitButton").show()

func hide_submit():
	get_node("SubmitButton").hide()

func show_title():
	get_node("TitleFrame").show()

func hide_title():
	get_node("TitleFrame").hide()

func _on_SubmitButton_pressed():
	var to_show = Global.stop()
	get_node("TitleFrame/TitleLabel").set_text(str("the ", to_show["mo"], " ", to_show["reputation"], " ", to_show["title"]))
	get_tree().set_pause(true)
	hide_submit()
	show_title()

func _on_RetryButton_pressed():
	get_tree().set_pause(false)
	Global.restart()
	get_node("TitleFrame/TitleLabel").set_text("")
	hide_title()

func _on_QuitButton_pressed():
	get_tree().set_pause(false)
	Global.add_to_score(-Global.score)
	get_tree().change_scene("res://MainMenu.tscn")
