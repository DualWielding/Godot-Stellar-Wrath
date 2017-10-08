extends Node2D

var sun_class = preload("res://Sun.tscn")
var asteroid_class = preload("res://Asteroid.tscn")
var asteroid
var planet_classes = Global.planet_classes
var number_of_planets = 20
onready var ui = get_node("InGameUI")

var terran_up
var shot
var asteroid_alive

var center

func _ready():
	get_node("StreamPlayer").play()
	Global.space = self
	set_process(true)
	set_process_input(true)
	
	generate_system()

func generate_system():
	terran_up = true
	shot = false
	asteroid_alive = true
	
	# Create the asteroid
	asteroid = asteroid_class.instance()
	asteroid.set_pos(Vector2(10, 10))
	add_child(asteroid)
	
	# Crate the sun
	center = get_viewport().get_rect().size / 2
	var s = sun_class.instance()
	s.set_pos(center)
	add_child(s)
	
	# Generate planets
	for index in range(number_of_planets):
		var planet_idx = randi() % planet_classes.size()
		# This is so ugly :/
		if planet_idx == 4:
			if terran_up:
				terran_up = false
			else:
				while planet_idx == 4:
					planet_idx = randi() % planet_classes.size()
		else:
			if terran_up:
				planet_idx = randi() % planet_classes.size()
				if planet_idx == 4:
					terran_up = false
		
		var p = planet_classes[planet_idx].instance()
		var ang = rand_range(0, 360)
		var pos = Vector2(0, 0)
		pos.x = center.x + (180 + (48 - index * 1.8) * index+1) * sin(ang)
		pos.y = center.y + (180 + (48 - index * 1.8) * index+1) * cos(ang)
		p.set_pos(pos)

		var f = pos - Global.sun_position
		var f1 = Vector2(f.y, -f.x).normalized()*2
		var f2 = Vector2(-f.y, f.x).normalized()*2
		p.velocity = [f1, f2][randi()%2]
		add_child(p)

func remove_system():
	for thing in get_tree().get_nodes_in_group("planet"):
		thing.queue_free()
	for thing in get_tree().get_nodes_in_group("shard"):
		thing.queue_free()
	for thing in get_tree().get_nodes_in_group("junk"):
		thing.queue_free()
	for thing in get_tree().get_nodes_in_group("asteroid"):
		thing.queue_free()
	for thing in get_tree().get_nodes_in_group("expendable_sp"):
		thing.queue_free()
	for thing in get_tree().get_nodes_in_group("sun"):
		thing.queue_free()

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON\
	and event.button_index == BUTTON_LEFT\
	and event.pressed\
	and asteroid_alive:
		asteroid.launch(get_global_mouse_pos())
		shot = true
		ui.show_submit()

func _on_Area2D_input_event( viewport, event, shape_idx ):
	var gmp = get_global_mouse_pos()
	if event.type == InputEvent.MOUSE_BUTTON\
	and event.button_index == BUTTON_RIGHT\
	and event.pressed\
	and gmp.distance_to(Global.sun_position) > get_viewport().get_rect().size.y / 4\
	and !shot:
		asteroid.set_global_pos(gmp)
		if gmp.x > center.x:
			asteroid.get_node("Sprite").set_flip_v(true)
		else:
			asteroid.get_node("Sprite").set_flip_v(false)