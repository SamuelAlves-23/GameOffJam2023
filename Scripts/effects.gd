extends AnimatedSprite2D

enum ENEMY_STATES{
	PARALYZED
}

var state

func _ready():
	self.animation_finished.connect(_on_animation_finished)
	frame = 0

func _on_animation_finished():
	queue_free()
