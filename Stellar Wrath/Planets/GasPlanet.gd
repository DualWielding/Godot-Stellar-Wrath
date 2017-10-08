extends "res://Planets/Planet.gd"

func _ready():
	add_to_group("gas_planet")

func _on_Area2D_body_enter( body ):
	if body.is_in_group("planet") and !body.been_hit:
		return
	
	if body.is_in_group("asteroid") and body.launched:
		Global.number_of_explosions_directly_provoked += 1
		explode(1, 1)
	elif body.is_in_group("inferno_planet"):
		explode(1, 1)
	elif body.is_in_group("sand_planet") or body.is_in_group("water_planet"):
		Global.transform_planet(body, "gas")

func explode(radius_ratio, strength_ratio):
	Global.add_to_score(17)
	Global.emit_shockwave(get_global_pos(), radius_ratio, strength_ratio)
	exploding = true
	get_node("Xplozion").show()
	ap.play("Explode")
	sp.play("GasBoom")
	get_node("Sprite").hide()
	set_collision_mask_bit(0, false)
	set_layer_mask_bit(0, false)
	set_collision_mask_bit(1, false)
	set_layer_mask_bit(1, false)
	orbit = false
	set_linear_velocity(Vector2(0, 0))
	set_angular_velocity(0)
	ap.connect("finished", self, "die")