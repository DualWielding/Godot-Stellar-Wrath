extends "res://Planets/Planet.gd"

var scored = false
var shaved = null

func _ready():
	add_to_group("terran_planet")
	ap.play("Glow")

func _on_Area2D_body_enter( body ):
	
	if body.is_in_group("asteroid") and body.launched:
		sp.play("TerranBoom")
		if !scored:
			Global.add_to_score(100)
			scored = true
			Global.mo.remove(Global.mo.find("Forgettable"))
			Global.mo.remove(Global.mo.find("Proxy"))
			Global.mo.append("Unstoppable")
			Global.mo.append("Relentless")
			Global.mo.append("Merciless")
		if shaved:
			shaved = false
			Global.mo.remove(Global.mo.find("Sneaky"))
			Global.mo.remove(Global.mo.find("Noticed"))
	elif body.is_in_group("shard") and !scored:
		Global.mo.append("Proxy")

func _on_ShavingArea_body_enter( body ):
	if shaved == null and body.is_in_group("asteroid") and body.launched :
		shaved = true
		Global.mo.append("Sneaky")
		Global.mo.append("Noticed")