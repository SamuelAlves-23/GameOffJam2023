extends Area2D
@export var direction = Vector2.ZERO
@export var speed = 600
@export var min_size = Vector2(0.1,0.1)
@export var max_size = Vector2(2,2)
@export var size_variation = Vector2(0.2,0.2)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(direction.normalized() * delta * speed)

func _physics_process(delta):
	if Input.is_action_just_pressed("increase_bullet_size"):
		change_bullet_size(size_variation)
	if Input.is_action_just_pressed("decrease_bullet_size"):
		change_bullet_size(-size_variation)

func change_bullet_size(variation):
	self.scale += variation
	self.scale.clamp(min_size, max_size)
