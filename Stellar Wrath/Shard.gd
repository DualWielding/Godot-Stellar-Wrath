extends RigidBody2D

onready var ap = get_node("AnimationPlayer")

var sp_class = preload("res://GlobalSamplesPlayer.tscn")
var sp

func set_type(exploding_planet, explosion_type = false):
	var color
	var frame
	if exploding_planet.is_in_group("ice_planet"):
		frame = 2
		color = Color("ffffff")
	elif exploding_planet.is_in_group("rock_planet"):
		frame = 2
		color = Color("c99234")
	elif exploding_planet.is_in_group("inferno_planet"):
		frame = 2
		color = Color("f60d0d")
	get_node("Sprite").set_modulate(color)
	get_node("Sprite").set_frame(frame)
	get_node("OverlayGlow/Sprite").set_modulate(color)
	set_scale(exploding_planet.get_scale())

func _ready():
	add_to_group("shard")
	set_angular_velocity(rand_range(-5, 5))
	sp = sp_class.instance()
	get_parent().add_child(sp)
	sp.add_to_group("expendable_sp")

func _on_Area2D_body_enter( body ):
	if body != self:
		explode()
		
		if body.is_in_group("planet"):
			Global.number_of_planets_hit_by_shards += 1
			Global.add_to_score(15)

func explode():
	Global.add_to_score(2)
	sp.play("ShardTouch")
	set_linear_velocity(Vector2(0, 0))
	set_angular_velocity(0)
	set_collision_mask_bit(0, false)
	set_layer_mask_bit(0, false)
	get_node("Sprite").hide()
	get_node("OverlayGlow").hide()
	get_node("Xplozion").show()
	ap.play("Explode")
	ap.connect("finished", self, "queue_free")
	Global.generate_junk(get_global_pos(), 1, 5)

func fry_in_sun():
	sp.play("Frying2")
	queue_free()