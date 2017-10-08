extends Node

var score = 0

var shard_class = preload("res://Shard.tscn")
var space
var sun_position = Vector2(0, 0)

var base_explosion_radius = 300
var base_explosion_strength = 350

var mo
var reputation
var titles

var number_of_planets_directly_hit
var number_of_planets_destroyed
var number_of_planets_hit_by_shards
var number_of_explosions_provoked
var number_of_explosions_directly_provoked
var number_of_planets_out_of_board
var number_of_junk_created

signal score_changed

var junk_class = preload("res://Junk.tscn")

var planet_classes = [
	preload("res://Planets/SandPlanet.tscn"),
	preload("res://Planets/GasPlanet.tscn"),
	preload("res://Planets/RockPlanet.tscn"),
	preload("res://Planets/ToxicPlanet.tscn"),
	preload("res://Planets/TerranPlanet.tscn"),
	preload("res://Planets/IcePlanet.tscn"),
	preload("res://Planets/WaterPlanet.tscn"),
	preload("res://Planets/InfernoPlanet.tscn")
]

func _ready():
	connect("score_changed", self, "show_score")
	start()

func start():
	score = 0
	mo = []
	titles = []
	
	number_of_planets_directly_hit = 0
	number_of_planets_destroyed = 0
	number_of_planets_hit_by_shards = 0
	number_of_explosions_provoked = 0
	number_of_explosions_directly_provoked = 0
	number_of_planets_out_of_board = 0
	number_of_junk_created = 0

func restart():
	start()
	add_to_score(-score)
	space.remove_system()
	space.generate_system()

func stop():
	if mo.size() == 0:
		mo.append("Unknown")
	
	if number_of_planets_hit_by_shards >= 7:
		titles.append("Rock Herault")
	elif number_of_planets_hit_by_shards >= 5:
		titles.append("Death Bringer")
	
	if number_of_planets_destroyed >= 5:
		titles.append("Worlds Slayer")
	
	if number_of_planets_out_of_board >= space.number_of_planets * 0.75:
		titles.append("Light Extinguisher")
	elif number_of_planets_out_of_board >= space.number_of_planets * 0.5:
		titles.append("Cold Establisher")
	
	if number_of_explosions_directly_provoked >= 3:
		titles.append("Instability Settler")
	
	if number_of_explosions_provoked >= 7:
		titles.append("Micro-Waver")
	
	if number_of_junk_created >= 150:
		titles.append("Junk Lover")
	elif number_of_junk_created >= 50:
		titles.append("Hooligan")
	
	if titles.size() == 0:
		if number_of_planets_directly_hit == 0:
			titles.append("Space Fart")
		elif number_of_planets_directly_hit == 1:
			titles.append("Stellar Shame")
		elif number_of_planets_directly_hit < 4:
			titles.append("Cosmic Averager")
		else:
			titles.append("Galactic Performer")
	
	if score == 0:
		reputation = "Ridiculous"
	elif score == 666:
		reputation = "Satanic"
	elif score == 42:
		reputation = "Know-it-all"
	elif score <= 10:
		reputation = "Farcical"
	elif score <= 100:
		reputation = "Prankish"
	elif score <= 160:
		reputation = "Would-be"
	elif score <= 300:
		reputation = "Stout"
	elif score <= 450:
		reputation = "Frightening"
	elif score <= 750:
		reputation = "Dreadfull"
	elif score <= 900:
		reputation = "Legendary"
	else:
		reputation = "Almighty"
	
	return {
		"mo": mo[randi()%mo.size()],
		"title": titles[randi()%titles.size()],
		"reputation": reputation
	}

func emit_shockwave(starting_point, radius_ratio, strength_ratio):
	var radius = base_explosion_radius * radius_ratio
	var strength = base_explosion_strength * strength_ratio
	var affected_bodies = get_tree().get_nodes_in_group("planet")
	for shard in get_tree().get_nodes_in_group("shard"):
		affected_bodies.append(shard)
	
	for body in affected_bodies:
		if body.is_in_group("planet"):
			body.been_hit = true
			if body.is_in_group("terran_planet") and !body.scored:
				mo.append("Earthquaking")
		if !body.is_in_group("planet") or !body.exploding:
			var dist = starting_point.distance_to(body.get_global_pos())
			if dist <= radius:
				var ratio = dist/radius
				body.apply_impulse(starting_point, (body.get_global_pos() - starting_point).normalized() * strength * ratio)
	
	generate_junk(starting_point)
	number_of_explosions_provoked += 1

func emit_shards(planet, number_of_shards):
	for i in range(number_of_shards):
		var s = shard_class.instance()
		s.set_type(planet)
		s.set_pos(planet.get_pos() + Vector2(25, 25).rotated(i * 6.28/number_of_shards))
		s.set_rot(rand_range(0, PI*2))
		space.add_child(s)
		s.apply_impulse(planet.get_pos(), (s.get_pos() - planet.get_pos()).normalized() * 300)
	
	generate_junk(planet.get_global_pos())

func generate_junk(center, minimum = 4, maximum = 12):
	for i in range(floor(rand_range(minimum, maximum))):
		var j = junk_class.instance()
		j.set_global_pos(Vector2(center.x - rand_range(-15, 15), center.y - rand_range(-15, 15)))
		j.set_rot(rand_range(0, PI*2))
		j.set_frame(randi()%5)
		space.add_child(j)
		
		number_of_junk_created += 1

func transform_planet(original_planet, new_type):
	if original_planet.asteroid_eaten:
		titles.append("Planet Chomped")
	var speed = original_planet.get_linear_velocity()
	var velocity = original_planet.velocity
	var pos = original_planet.get_pos()
	original_planet.queue_free()
	var planet_class
	if new_type == "gas":
		planet_class = planet_classes[1]
	elif new_type == "toxic":
		planet_class = planet_classes[3]
	var p = planet_class.instance()
	#p.orbit = false # FOR TESTS
	p.set_pos(pos)
	space.add_child(p)
	p.set_linear_velocity(speed)
	p.velocity = velocity

func add_to_score(number):
	score += number
	emit_signal("score_changed")

func show_score():
	space.get_node("InGameUI/CurrentScore").set_text(str(score))