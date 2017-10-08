extends "res://Planets/Planet.gd"

var shard_class = preload("res://Shard.tscn")

func _ready():
	add_to_group("rock_planet")

func _on_Area2D_body_enter( body ):
	if body == self:
		return
	if body.is_in_group("planet") and !body.been_hit:
		return
	
	if body.is_in_group("asteroid") and body.launched:
		explode_in_shards(8)
	elif body.is_in_group("ice_planet") or body.is_in_group("rock_planet"):
		explode_in_shards(8)
	elif body.is_in_group("inferno_planet"):
		explode_in_shards(4)
#	if body.is_in_group("sand_planet") or body.is_in_group("water_planet"):
#		get_absorbed_by(body)

func explode_in_shards(number_of_shards):
	Global.add_to_score(24)
	Global.emit_shards(self, number_of_shards)
	exploding = true
	get_node("Xplozion").show()
	ap.play("Explode")
	sp.play("TelluricBoom")
	get_node("Sprite").hide()
	set_collision_mask_bit(0, false)
	set_layer_mask_bit(0, false)
	set_collision_mask_bit(1, false)
	set_layer_mask_bit(1, false)
	orbit = false
	set_linear_velocity(Vector2(0, 0))
	set_angular_velocity(0)
	ap.connect("finished", self, "die")

#func get_absorbed_by(planet):
#	get_node("CollisionShape2D").set_trigger(true)
#	ap.play("Reduce")
#	ap.connect("finished", self, "queue_free")