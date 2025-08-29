extends CharacterBody2D

@onready var body_sprite = $BodySprite
@onready var attack_cooldown = $AttackCooldown

var red_team_skin = preload("res://assets/sprites/pewerbody.png")
var blue_team_skin = preload("res://assets/sprites/pewerbodyblue.png")

var bullet_scene = preload("res://scenes/bullets/bullet.tscn")

var initialized = false

var bullet_speed = 400

var speed = 200

var health = 10
var damage = 2

# full 360 rotations per second
#var rot_speed = PI/128
var target_position = Vector2()
var attack_range = 200

## Tracks how many game cycles before next firing attempt
var firing_cooldown_counter = 0

func _ready():
	pass

func _process(delta):
	if health <= 0:
		## Character dies when HP is 0
		queue_free()
	if not initialized:
		initialize()
	target_position = get_global_mouse_position()
	acquire_target()
	var direction = (target_position - position).normalized()
	var forward_direction = Vector2(cos(rotation), sin(rotation)).normalized()
	#rotation += PI/256
	rotation = position.angle_to_point(target_position)
	if position.distance_to(target_position) > attack_range:
		velocity.x = forward_direction.x*speed
		velocity.y = forward_direction.y*speed
		move_and_slide()
	else:
		shoot(target_position)


func shoot(target_position: Vector2):	
	if attack_cooldown.is_stopped():
		var shooter_groups = get_groups()
		
		print("This pewers team is: ",shooter_groups)
		print('BANG!!!')
		attack_cooldown.start(1)
		
		var bullet = bullet_scene.instantiate()
		var direction = (target_position - position).normalized()
		
		bullet.position = position
		bullet.velocity = direction*bullet_speed
		bullet.damage = damage
		
		if "Team1" in shooter_groups:
			bullet.add_to_group("Team1Projectile")
			bullet.owning_team="Team1"
		elif "Team2" in shooter_groups:
			bullet.add_to_group("Team2Projectile")
			bullet.owning_team="Team2"
		
		
		## TODO 20250824: determine if root is sufficient for the purposes of this game for the bullet
		## to be spawned from
		## Consider options:
		## https://stackoverflow.com/questions/73519196/child-node-bullet-follows-parent-node-revolver-in-godot
		get_tree().root.add_child(bullet)


## Gets list of all enemies in the area, then chooses the one closest to it
func acquire_target():
	var enemies
	get_groups()
	if is_in_group("Team1"):
		enemies = get_tree().get_nodes_in_group("Team2")
	elif is_in_group("Team2"):
		enemies = get_tree().get_nodes_in_group("Team1")
	
	if len(enemies) <= 0:
		pass
	
	var closest = null
	closest = enemies[0] if len(enemies)>0 else null
	for enemy in enemies:
		if position.distance_to(enemy.position) < position.distance_to(closest.position):
			closest = enemy
	
	## stops
	if closest != null:
		target_position = closest.position
		
	


func take_hit(bullet):
	health -= bullet.damage
	## TODO: if bullets have special effects, add their impacts on their target here
	
	## Destroy the bullet
	bullet.queue_free()

## should be called whenever instantiating this character
func initialize(groupname:String="Team1"):
	initialized = true
	## If somehow an invalid group name was passed, default to Team1
	#if get_tree() != null:
	#	groupname = "Team1" if len(get_tree().get_nodes_in_group(groupname)) == 0 else groupname
		
		
	add_to_group(groupname)
	if is_in_group("Team2"):
		body_sprite.texture = blue_team_skin
		pass
	pass

func get_sprite() -> Sprite2D:
	return body_sprite


func _on_clickable_area_input_event(viewport, event, shape_idx):
	if (event.is_action_pressed("left_click")):
		print("LEFT CLICK PRESSED!")
