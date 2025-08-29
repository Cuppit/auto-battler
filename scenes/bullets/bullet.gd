extends Node2D

var velocity = Vector2()
var owning_team = "Team1"
var damage = 2

func _ready():
	print("bullet spawned. it's groups:",get_groups(),", owning team: ",owning_team)


func _process(delta):
	position.x += velocity.x*delta
	position.y += velocity.y*delta
	if position.x < 0 or position.x > get_viewport().size.x or position.y < 0 or position.y > get_viewport().size.y:
		print('DELETING BULLET:')
		queue_free()  # Remove the bullet if it goes off-screen


func _on_bullet_area_body_entered(body):
	pass

	var tgt_team = body.get_groups()
	if (owning_team == "Team1") and ("Team2" in tgt_team):
		print("This bullet is in team1, and it collided with a member of team2!  DOING DAMAGE!")
		body.take_hit(self)
	elif (owning_team == "Team2") and ("Team1" in tgt_team):
		print("This bullet is in team2, and it collided with a member of team1!  DOING DAMAGE!")
		body.take_hit(self)
		
