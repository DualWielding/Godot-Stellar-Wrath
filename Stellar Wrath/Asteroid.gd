extends RigidBody2D

var launched = false
var first_hit = false

var last_planet_hit = null

var sp_class = preload("res://GlobalSamplesPlayer.tscn")
var sp = sp_class.instance()

func _ready():
	sp.add_to_group("expendable_sp")
	get_parent().add_child(sp)
	add_to_group("asteroid")
	set_process(true)

func _process(delta):
	if !launched:
		set_rot(get_rot() - 3.14/2 + get_angle_to(get_global_mouse_pos()))

func launch(direction, speed = 400000):
	if !launched:
		if !first_hit:
			sp.play("AsteroidCrying")
		get_node("SpriteCrying").show()
		unfantomize()
		apply_impulse(Vector2(0, 0), (direction - get_global_pos()).normalized() * speed)
		launched = true

func stop():
	set_linear_velocity(Vector2(0, 0))

func fantomize():
	set_collision_mask_bit(0, false)
	set_layer_mask_bit(0, false)
	get_node("CollisionShape2D").set_trigger(true)
	get_node("Sprite").hide()

func unfantomize():
	set_collision_mask_bit(0, true)
	set_layer_mask_bit(0, true)
	get_node("CollisionShape2D").set_trigger(false)
	get_node("Sprite").show()

func _on_Area2D_area_enter_shape( area_id, area, area_shape, self_shape ):
	var body = area.get_parent()
	if body.is_in_group("planet"):
		if !first_hit:
			if body.is_in_group("terran_planet"):
				Global.mo.append("Xenophobic")
				Global.mo.append("Obsessed")
			first_hit = true
		if body != last_planet_hit: # For sand and water planets
			Global.number_of_planets_directly_hit += 1
		last_planet_hit = body

func fry_in_sun():
	sp.play("Frying1")
	Global.titles.append("Sun Diver")
	get_parent().asteroid_alive = false
	queue_free()