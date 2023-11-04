extends Area2D
@export var direction = Vector2.ZERO
@export var speed = 600
@export var min_size = 0.5
@export var max_size = 2
@export var size_variation = Vector2(0.2,0.2)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(direction.normalized() * delta * speed)


func change_bullet_size(variation):
	self.scale += variation
	self.scale.x = clamp(self.scale.x, min_size, max_size)
	self.scale.y = clamp(self.scale.y, min_size, max_size)


func _on_area_entered(area):
	queue_free()
	area.take_damage(scale.x * 10)
