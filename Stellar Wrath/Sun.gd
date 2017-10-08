extends Node2D

var solar_eruption_class = preload("res://SolarEruption.tscn")

func _ready():
	get_node("AnimationPlayer").play("Burn")
	add_to_group("sun")
	Global.sun_position = get_pos()

func _on_Destruction_body_enter( body ):
	
	var se_pos = get_pos()
	var se = solar_eruption_class.instance()
	se.set_scale(Vector2(0.28, 0.28))
	se.set_pos(se_pos)
	se.set_rot(get_rot() + get_angle_to(body.get_global_pos()) + 3.14)
	get_parent().add_child(se)
	se.get_node("AnimationPlayer").play("Erupt")
	randomize()
	
	if body.is_in_group("terran_planet"):
		Global.add_to_score(101)
		Global.titles.append("Life extinguisher")
		body.fry_in_sun()
	elif body.is_in_group("planet"):
		Global.add_to_score(52)
		body.fry_in_sun()
	elif body.is_in_group("shard") or body.is_in_group("asteroid"):
		body.fry_in_sun()
	else:
		body.queue_free()

func _on_Destruction_area_enter( area ):
	pass
#	if area != get_node("Attraction"):
#		var r = get_node("Destruction/CollisionShape2D").get_shape().get_radius()
#		var se_pos = get_node("Sprite").get_global_pos()
#		var se_pos = Vector2(get_pos().x + r * cos(get_angle_to(area.get_global_pos())), get_pos().y + r * sin(get_angle_to(area.get_global_pos())))
#		var se = solar_eruption_class.instance()
#		se.set_pos(se_pos)
#		se.set_scale(Vector2(0.3, 0.3))
#		se.set_global_rot(get_global_rot() + get_angle_to(area.get_global_pos()) + 3.14)
#		get_parent().add_child(se)
#		se.get_node("AnimationPlayer").play("Erupt")
#		area.get_parent().queue_free()
	
#	if area != get_node("Attraction") and area != get_node("Destruction"):
#		var dir = (area.get_parent().get_global_pos() - get_global_pos()).normalized()
#		var se_pos = (area.get_parent().get_global_pos() - get_global_pos()) * dir
#		print(se_pos, get_pos())
#		var se = solar_eruption_class.instance()
#		se.set_pos(se_pos)
#		se.set_scale(Vector2(0.3, 0.3))
#		se.set_rot(get_rot() + get_angle_to(area.get_global_pos()) + 3.14)
#		add_child(se)
#		se.get_node("AnimationPlayer").play("Erupt")
#		area.get_parent().queue_free()