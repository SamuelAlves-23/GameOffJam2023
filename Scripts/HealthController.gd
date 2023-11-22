extends Node

@export var health = 3
@onready var parent = get_parent()
@onready var arena = get_tree().get_first_node_in_group("Arena")
var death_effect

func take_damage(damage):
	
	if !parent.invulnerable:
		health -= damage
		
	
	if parent is Player && !parent.invulnerable:
		parent.invulnerable = true
		print(parent.invulnerable)
		for i in 10:
			parent.sprite.visible = false
			await await get_tree().create_timer(0.1).timeout
			parent.sprite.visible = true
			await await get_tree().create_timer(0.1).timeout
		
		parent.invulnerable = false
		print(parent.invulnerable)
	if health <= 0 && parent is Enemy:
		arena.add_score()
		die()
		if arena.score % 10 == 0:
			arena.spawn_pickable(parent.global_position)

func heal():
	if health < 3:
		health += 1

func die():
	get_parent().queue_free()
#	var deathEffect = 
