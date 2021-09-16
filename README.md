# Exercise-02c-Asteroids-and-Enemies

Exercise for MSCH-C220, 14 September 2021

This exercise is an opportunity for you to play with physics bodies and collisions in Godot. The exercise will give you several pieces that should be useful for your implementation of Project 02.

Fork this repository. When that process has completed, make sure that the top of the repository reads [your username]/Exercise-02c-Asteroids-and-Enemies. Edit the LICENSE and replace BL-MSCH-C220-F21 with your full name. Commit your changes.

Press the green "Code" button and select "Open in GitHub Desktop". Allow the browser to open (or install) GitHub Desktop. Once GitHub Desktop has loaded, you should see a window labeled "Clone a Repository" asking you for a Local Path on your computer where the project should be copied. Choose a location; make sure the Local Path ends with "Exercise-02c-Asteroids-and-Enemies" and then press the "Clone" button. GitHub Desktop will now download a copy of the repository to the location you indicated.

Open Godot. In the Project Manager, tap the "Import" button. Tap "Browse" and navigate to the repository folder. Select the project.godot file and tap "Open".

You will now see a simple scene, containing of a Player node (a user-controlled ship) on a black background. There are several Node2D containers that we will be adding elements to during the development of the exercise.

---

Create a new scene. Select Other Node and then search for KinematicBody2D (the blue node, not the pink one!). Rename the new node Enemy Add a Sprite as a child of the Enemy (use res://Assets/enemy.png), and create a corresponding CollisionPolygon2D. Add a Timer as a chidl of the Enemy node.

Attach a script (res://Enemy/Enemy.gd) to the Enemy node. The script should be as follows:
```
extends KinematicBody2D

var VP = Vector2.ZERO
var direction = 0.0
var dir_speed = 0.01
var velocity = Vector2(2,0)

var Bullets = null
var Enemy_Bullet = preload("res://Enemy_Bullet/Enemy_Bullet.tscn")

var Explosion = preload("res://Explosion/Explosion_ship.tscn")
var Explosions = null


func _ready():
	VP = get_viewport().size
	randomize()

func _physics_process(_delta):
	direction += dir_speed
	while direction > 2*PI:
		direction -= 2*PI

func die():
	if Explosions == null:
		Explosions = get_node_or_null("/root/Game/Explosions")
	if Explosions != null:
		var explosion = Explosion.instance()
		explosion.position = position
		Explosions.add_child(explosion)
	queue_free()
```
In the Node Panel->Groups, make sure the Enemy is in the "enemy" group. Then select the Timer. 

The Timer should be set to Autostart with a Wait Time of 0.6 seconds. Add a new Node->Signals->timeout() signal. Attach the _on_Timer_timeout() method to the Enemy.gd script. That will create a new function at the bottom of your script. That function should appear as follows:
```
func _on_Timer_timeout():
	if Bullets == null:
		Bullets = get_node("/root/Game/Bullets")
	if Bullets != null:
		var bullet = Enemy_Bullet.instance()
		bullet.position = position
		bullet.rotation = direction
		Bullets.add_child(bullet) 
```

Save the scene as res://Enemy/Enemy.tscn. Close the scene and go back to res://Game.tscn.

Right-click on the Enemies node and "Instance Child Scene" select res://Enemy/Enemy.tscn. After selecting the new Enemy node, set the Node2D->Transform->Position = (200,200).

---

Create a new scene. Select Other Node and then search for RigidBody2D (blue, not pink). Rename the new node Asteroid. Add a Sprite as a child of the Asteroid (use res://Assets/asteroid_large.png), and create a corresponding CollisionShape2D or CollisionPolygon2D.

In the Inspector Panel for the Asteroid node, update the following:
```
Mass->50
Weight->490
Gravity Scale->0
Linear Velocity->(30,-30)
Linear Damp->0
Physics Material->New Physics Material
    (edit the new Physics Material)
    Friction->0.2
    Bounce->0.75
```

Attach a script to the Asteroid node (res://Asteroid/Asteroid.gd). The script should be as follows:
```
extends RigidBody2D

var screensize = Vector2.ZERO

func _ready():
	screensize = get_viewport().size

func _integrate_forces(state):
	var t = state.get_transform()
	t.origin.x = wrapf(t.origin.x,0,screensize.x)
	t.origin.y = wrapf(t.origin.y,0,screensize.y)
	state.set_transform(t)
```

Finally, in the Node panel (tab next to the inspector panel). Select Groups, and make the Asteroid node part of the "asteroid" group.

Save the scene as res://Asteroid/Asteroid.tscn. Close the scene and go back to res://Game.tscn.

Right-click on the Asteroids node and "Instance Child Scene" select res://Asteroid/Asteroid.tscn. After selecting the new Asteroid node, set the Node2D->Transform->Position = (800,500).

---

THe last step will be for you to set up the collision layers so the enemy and the ship can shoot without blowing themselves up. I would recommend the following:
 * Layer 1: Player
 * Layer 2: Enemy
 * Layer 3: Asteroid
 * Layer 4: Bullet

I will leave it up to you to figure out what layers and masks are appropriate for the different physics bodies.

---

Test it and make sure this is working correctly. You should be able to fly around the screen (with wraparound), crash into the asteroid, shoot the enemy. If your player is killed, you will need to quit (Escape) and start again.

Quit Godot. In GitHub desktop, you should now see the updated files listed in the left panel. In the bottom of that panel, type a Summary message (something like "Completes the exercise") and press the "Commit to master" button. On the right side of the top, black panel, you should see a button labeled "Push origin". Press that now.

If you return to and refresh your GitHub repository page, you should now see your updated files with the time when they were changed.

Now edit the README.md file. When you have finished editing, commit your changes, and then turn in the URL of the main repository page (https://github.com/[username]/Exercise-02c-Asteroids-and-Enemies) on Canvas.

The final state of the file should be as follows (replacing my information with yours):
```
# Exercise-02c-Asteroids-and-Enemies
Exercise for MSCH-C220, 14 September 2021

A simple 2D space game exploring Godot collisions and Physics Bodies.

## To play
Use W to accelerate the player. Rotate with A and D. Press Space to shoot.

## Implementation
Built using Godot 3.3.3

## References
Assets provided by [kenney.nl](https://kenney.nl/assets/simple-space)
Explosion sprite sheets provided by [StumpyStrust](https://opengameart.org/content/explosion-sheet) and [Cuzco](https://opengameart.org/content/explosion)

## Future Development
None

## Created by 
Jason Francis
```