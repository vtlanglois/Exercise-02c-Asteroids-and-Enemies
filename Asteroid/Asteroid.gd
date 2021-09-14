extends KinematicBody2D

var VP = Vector2.ZERO
var velocity = Vector2(1,0)
var min_speed = 0.1
var max_speed = 2

func _ready():
	VP = get_viewport().size
	randomize()
	velocity = velocity.normalized().rotated(randf()*2*PI) * clamp(randf()*max_speed + min_speed, min_speed, max_speed)

func _physics_process(_delta):
	position += velocity
	position.x = wrapf(position.x,0,VP.x)
	position.y = wrapf(position.y,0,VP.y)


