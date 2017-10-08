extends "res://Planets/Planet.gd"

func _ready():
	add_to_group("inferno_planet")

func _on_Area2D_body_enter( body ):
	if body == self:
		return
	if body.is_in_group("planet") and !body.been_hit:
		return
	
	if body.is_in_group("asteroid") and body.launched:
		Global.number_of_explosions_directly_provoked += 1
		explode_with_shards(4)
	elif body.is_in_group("gas_planet") or body.is_in_group("toxic_planet"):
		explode(1, 1)
	elif body.is_in_group("rock_planet") or body.is_in_group("ice_planet"):
		explode(1, 1)
	elif body.is_in_group("inferno_planet"):
		explode_with_shards(4)
	elif body.is_in_group("sand_planet") or body.is_in_group("water_planet"):
		explode(1, 1)

func explode_with_shards(number_of_shards):
	Global.add_to_score(26)
	Global.emit_shockwave(get_global_pos(), 1.5, 1.5)
	exploding = true
	get_node("Xplozion").show()
	ap.play("Explode")
	sp.play("InfernoBoom")
	get_node("Sprite").hide()
	set_collision_mask_bit(0, false)
	set_layer_mask_bit(0, false)
	set_collision_mask_bit(1, false)
	set_layer_mask_bit(1, false)
	orbit = false
	set_linear_velocity(Vector2(0, 0))
	set_angular_velocity(0)
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	t.connect("timeout", Global, "emit_shards", [self, number_of_shards])
	get_parent().add_child(t)
	t.start()
	ap.connect("finished", self, "die")
	

func explode(radius_ratio, strength_ratio):
	Global.add_to_score(26)
	Global.emit_shockwave(get_global_pos(), radius_ratio, strength_ratio)
	exploding = true
	get_node("Xplozion").show()
	ap.play("Explode_light")
	sp.play("InfernoBoom")
	get_node("Sprite").hide()
	set_collision_mask_bit(0, false)
	set_layer_mask_bit(0, false)
	set_collision_mask_bit(1, false)
	set_layer_mask_bit(1, false)
	orbit = false
	set_linear_velocity(Vector2(0, 0))
	set_angular_velocity(0)
	ap.connect("finished", self, "die")