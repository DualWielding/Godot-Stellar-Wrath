extends RigidBody2D

var velocity = Vector2(1, 0)
var G = 2000.0
var been_hit = false
export var orbit = true

onready var ap = get_node("AnimationPlayer")
var sp

var exploding = false

var out_of_board = false
var angular_velocity

var sp_class = preload("res://GlobalSamplesPlayer.tscn")

var size = rand_range(0.86, 1.14)

func _ready():
	add_to_group("planet")
	randomize()
	angular_velocity = rand_range(-4, 4)
	set_fixed_process(true)
	sp = sp_class.instance()
	get_parent().add_child(sp)
	sp.add_to_group("expendable_sp")

func _fixed_process(delta):
	# Have to rescale them every frame. Don't know why.
#	if get_scale().x != size:
#		set_scale(Vector2(size, size))
	if orbit:
		step_euler(Global.sun_position)
	if !out_of_board and get_global_pos().distance_to(Global.sun_position) > 1200:
		out_of_board = true
		Global.add_to_score(37)
		Global.number_of_planets_out_of_board += 1
		if is_in_group("terran_planet"):
			Global.mo.append("Cooling")
	if !been_hit:
		set_angular_velocity(angular_velocity)

func step_euler(center):
	var step = 8
	for i in range(step):
		var dt = 1.0/step
		var acc = acceleration(center, get_pos())
		var a = get_linear_velocity()
		velocity = Vector2(velocity.x + acc.x * dt, velocity.y + acc.y * dt)
		set_pos(Vector2(get_pos().x + velocity.x * dt, get_pos().y + velocity.y * dt))

func acceleration(pos1, pos2):
	var direction = Vector2(pos1.x - pos2.x, pos1.y - pos2.y)
	var length = sqrt(direction.x * direction.x + direction.y*direction.y)
	var normal = Vector2(direction.x/length, direction.y/length)
	return Vector2(normal.x*(G/pow(length, 2)), normal.y*(G/pow(length, 2)))

func die():
	Global.number_of_planets_destroyed += 1
	queue_free()

func fry_in_sun():
	sp.play("Frying1")
	die()

#func set_velocity(on_x_axis):
#	if on_x_axis:
#		if get_pos().x < Global.sun_position.x:
#			velocity = Vector2(0, -1)
#		else:
#			velocity  = Vector2(0, 1)
#	else:
#		if get_pos().y < Global.sun_position.y:
#			velocity = Vector2(1, 0)
#		else:
#			velocity  = Vector2(-1, 0)

################### OTHER WAY

#func _ready():
#	randomize()
#	set_mass(rand_range(1, 8))
#	var f = get_global_pos() - get_parent().get_node("Sun").get_pos()
#	var f1 = Vector2(f.y, -f.x)
#	var f2 = Vector2(-f.y, f.x)
#	randomize()
#	var selected = [f1, f2][randi() % 2]
#	apply_impulse(Vector2(0, 0), f*0.4)
#
#func _integrate_forces(state):
#	var f = get_global_pos() - get_parent().get_node("Sun").get_pos()
#	apply_impulse(Vector2(0, 0), f * 0.01 * get_mass())
#	apply_impulse(Vector2(0, 0), -f * 0.1 * get_mass())
#	f = Vector2(f.y, -f.x)
#	apply_impulse(Vector2(0, 0), f * 0.01 * get_mass())

func _on_BeenHitDetection_body_enter( body ):
	if body.is_in_group("asteroid") or body.is_in_group("shard") or (body.is_in_group("planet") and body.been_hit):
		been_hit = true
	if body.is_in_group("asteroid"):
		body.sp.stop_all()
		body.get_node("SpriteCrying").hide()
