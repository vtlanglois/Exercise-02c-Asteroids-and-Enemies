extends KinematicBody2D

var VP = Vector2.ZERO
var direction = 0
var velocity = Vector2(2,0)

var Bullets = null
var Enemy_Bullet = preload("res://Enemy_Bullet/Enemy_Bullet.tscn")

func _ready():
	VP = get_viewport().size
	randomize()
	position = Vector2(-40,400)

func _physics_process(_delta):
	position += velocity
	if position.x > VP.x + 50 or position.x < -50:
		queue_free()

func die():
	queue_free()

func _on_Timer_timeout():
	if Bullets == null:
		Bullets = get_node("/root/Game/Bullets")
	if Bullets != null:
		var bullet = Enemy_Bullet.instance()
		var b_dir = randf() * 2 * PI
		bullet.position = position + Vector2(0,-40).rotated(b_dir)
		bullet.rotation = b_dir
		Bullets.add_child(bullet) 
