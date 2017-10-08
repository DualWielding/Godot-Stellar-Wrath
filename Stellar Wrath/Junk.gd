extends Sprite

var velocity = Vector2(0, 1)
var G = 500.0

var out_of_board = false

func _ready():
	add_to_group("junk")
	var f = get_pos() - Global.sun_position
	velocity = Vector2(f.y, -f.x).normalized()
	set_process(true)

func _process(delta):
	if get_global_pos().distance_to(Global.sun_position) < 40:
		queue_free()
	step_euler(Global.sun_position)

func step_euler(center):
	var step = 8
	for i in range(step):
		var dt = 1.0/step
		var acc = acceleration(center, get_pos())
		velocity = Vector2(velocity.x + acc.x * dt, velocity.y + acc.y * dt)
		set_pos(Vector2(get_pos().x + velocity.x * dt, get_pos().y + velocity.y * dt))

func acceleration(pos1, pos2):
	var direction = Vector2(pos1.x - pos2.x, pos1.y - pos2.y)
	var length = sqrt(direction.x * direction.x + direction.y*direction.y)
	var normal = Vector2(direction.x/length, direction.y/length)
	return Vector2(normal.x*(G/pow(length, 2)), normal.y*(G/pow(length, 2)))