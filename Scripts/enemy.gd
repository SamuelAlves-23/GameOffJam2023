extends Area2D

#signal damaged

@onready var health_controller = $HealthController
@onready var collision_shape = $CollisionShape2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func take_damage(damage):
#	emit_signal("damaged")
	health_controller.take_damage(damage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
