extends Area2D
class_name Bullet
@export var direction = Vector2.ZERO
@export var speed = 600
@export var vanish_time = 0.5
@export var damage_multiplier = 20

#@onready var walls = get_tree().get_first_node_in_group("Walls")
@onready var vanish_effect = preload("res://Scenes/vanish_effect.tscn")
var damage 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	damage = scale.x * damage_multiplier
	translate(direction.normalized() * delta * speed)
	await get_tree().create_timer(vanish_time).timeout
	queue_free()
	var vanish_effect_instance = vanish_effect.instantiate()
	get_parent().add_child(vanish_effect_instance)
	vanish_effect_instance.scale = scale
	vanish_effect_instance.global_position = global_position  


func _on_area_entered(area):
	if scale > Vector2.ONE:
		scale -= Vector2(0.1,0.1)
	else:
		queue_free()


func _on_body_entered(body):
	if body is Walls:
		queue_free()
