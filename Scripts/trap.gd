extends Node2D

@onready var animationPlayer = $AnimationPlayer
# Called when the node enters the scene tree for the first time.

func _on_hitbox_body_entered(body):
	print("NUEVA ENTRDA TRAMPA")
	animationPlayer.play("Active")
	body.health_controller.take_damage(1)
