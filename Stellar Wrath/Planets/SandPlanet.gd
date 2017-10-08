extends "res://Planets/Planet.gd"

var time_before_spit = 2
var asteroid_eaten = false

func _ready():
	add_to_group("sand_planet")

func _on_Area2D_body_enter( body ):
	if body.is_in_group("asteroid") and body.launched:
		asteroid_eaten = true
		sp.play("SandChomp")
		Global.add_to_score(11)
		get_node("Glow").show()
		ap.play("Glow_timer")
		set_linear_velocity(get_linear_velocity().normalized() * 75)
		body.fantomize()
		body.stop()
		var t = Timer.new()
		t.set_wait_time(time_before_spit)
		t.connect("timeout", self, "spit", [body])
		t.set_one_shot(true)
		add_child(t)
		t.start()

func spit(body):
	get_node("Glow").hide()
	ap.stop(true)
	body.launched = false
	body.set_pos(get_pos() + (get_global_mouse_pos() - get_global_pos()).normalized() * 35)
	body.launch(get_global_mouse_pos())
	body.unfantomize()
	asteroid_eaten = false