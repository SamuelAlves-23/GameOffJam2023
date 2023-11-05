extends Area2D
@export var direction = Vector2.ZERO
@export var speed = 600

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(direction.normalized() * delta * speed)
	await get_tree().create_timer(0.5).timeout
	queue_free()


func _on_area_entered(area):
	if scale > Vector2.ONE:
		scale -= Vector2(0.25,0.25)
	else:
		queue_free()
	
	area.get_parent().take_damage(scale.x * 10)
