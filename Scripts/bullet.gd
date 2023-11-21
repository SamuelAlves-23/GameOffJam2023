extends Area2D
class_name Bullet
@export var direction = Vector2.ZERO
@export var speed = 600
@export var vanish_time = 0.5
@export var damage_multiplier = 10

@onready var walls = get_tree().get_first_node_in_group("Walls")
var damage 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	damage = scale.x * damage_multiplier
	translate(direction.normalized() * delta * speed)
	await get_tree().create_timer(vanish_time).timeout
	queue_free()


func _on_area_entered(area):
	if scale > Vector2.ONE:
		scale -= Vector2(0.25,0.25)
	else:
		queue_free()


func _on_body_entered(body):
	if body is Walls:
		queue_free()
