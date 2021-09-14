extends KinematicBody2D

var VP := Vector2.ZERO
var velocity := Vector2.ZERO
var acceleration := 0.2
var rotation_accel := 0.075
var max_speed := 9.0

var Bullet = preload("res://Bullet/Bullet.tscn")
var Bullets = null

func _ready():
	VP = get_viewport().size

func _physics_process(_delta):
	rotation += get_rotation()*rotation_accel
	velocity += get_input()*acceleration
	velocity = velocity.normalized() * clamp(velocity.length(),0,max_speed)
	position += velocity
	position.x = wrapf(position.x,0,VP.x)
	position.y = wrapf(position.y,0,VP.y)
	
	if Input.is_action_just_pressed("shoot"):
		if Bullets == null:
			Bullets = get_node_or_null("/root/Game/Bullets")
		if Bullets != null:
			var bullet = Bullet.instance()
			bullet.position = position + Vector2(0,-20).rotated(rotation)
			bullet.rotation = rotation
			Bullets.add_child(bullet)

func die():
	queue_free()

func get_input():
	var toReturn := Vector2.ZERO
	if Input.is_action_pressed("forward"):
		toReturn.y -= 1
		$Thrust.show()
	else:
		$Thrust.hide()
	return toReturn.rotated(rotation)

func get_rotation():
	var toReturn := 0.0
	if Input.is_action_pressed("right"):
		toReturn += 1.0
	if Input.is_action_pressed("left"):
		toReturn -= 1.0
	return toReturn


func _on_Collide_body_entered(body):
	if body.has_method("die"):
		body.die()
	die()
