extends CharacterBody2D
class_name Player

enum PLAYER_STATES{
	MOVE,
	RECOIL,
	HIT,
	DEATH
}

var state = PLAYER_STATES.MOVE
var damage_recoil_vector
var recoil_vector = Vector2.DOWN
var input_vector = Vector2.ZERO


@export var ACCELERATION = 500
@export var MAX_SPEED = 123
@export var RECOIL_SPEED = 10000
@export var FRICTION  = 500
@export var speed = 120.0
@export var dash_speed = 6
@export var gun_cd = false
@export var dash_cd = false
@export var size_variation = Vector2(0.5,0.5)
@export var cd_cap = 0.5
@export var death_wave = false

@onready var invulnerable = false
@onready var waveCollider = $WaveArea/WaveCollider
@onready var sprite = $Sprite2D
@onready var fire_effect = $FireEffect
@onready var gun = $Gun
@onready var health_controller = $HealthController
@onready var collision = $CollisionShape2D
@onready var hurtbox_collider = $Hurtbox/CollisionShape2D
@onready var arena = get_tree().get_first_node_in_group("Arena")
@onready var pickup_effect = preload("res://Scenes/pickup_effect.tscn")

func _process(delta):
	var direction = get_global_mouse_position().x
	if direction != 0:
		sprite.flip_h = (direction < self.global_position.x)
	
	match state:
		PLAYER_STATES.MOVE:
			move_state(delta)
		PLAYER_STATES.RECOIL:
			recoil_state(delta, gun.scale)
		PLAYER_STATES.HIT:
			hit_state(delta)
		PLAYER_STATES.DEATH:
			fire_effect.hide()
			sprite.hide()
			gun.hide() 
			

func move_state(delta):
	var direction = get_global_mouse_position().x
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move_and_slide()
	if Input.is_action_just_pressed("increase_bullet_size"):
		gun.change_gun_size(size_variation)
	if Input.is_action_just_pressed("decrease_bullet_size"):
		gun.change_gun_size(-size_variation)
	
	if Input.is_action_pressed("shoot") && !gun_cd:
		gun.shoot()
		if gun.scale > Vector2.ONE:
			state = PLAYER_STATES.RECOIL
		gun_cd = true
		arena.hud.set_reload_ui(cd_cap * gun.scale.x)
		await get_tree().create_timer(cd_cap * gun.scale.x).timeout
		gun_cd = false

func recoil_state(delta, gun_scale):
	var current_pos = global_position
	recoil_vector = -(get_global_mouse_position() - current_pos)
	recoil_vector = recoil_vector.normalized()
	velocity = RECOIL_SPEED * recoil_vector * delta * gun_scale
	move_and_slide()
	state = PLAYER_STATES.MOVE

func hit_state(delta):
	velocity = RECOIL_SPEED * damage_recoil_vector * delta * 3
	move_and_slide()
	state = PLAYER_STATES.MOVE

func _on_hurtbox_area_entered(area):
	if state != PLAYER_STATES.DEATH:
		if area is Pickable:
			AudioPlayer.play_sfx("pickup")
			pickable_effect(area.item_name)
			area.queue_free()
			var pick_up_effect_instance = pickup_effect.instantiate()
			area.get_parent().add_child(pick_up_effect_instance)
			pick_up_effect_instance.global_position = area.global_position  
		else:
			var current_pos = global_position
			damage_recoil_vector = -(area.global_position - current_pos)
			damage_recoil_vector = damage_recoil_vector.normalized()
			health_controller.take_damage(area.damage)
			if health_controller.health <= 0:
				state = PLAYER_STATES.DEATH
			else:
				state = PLAYER_STATES.HIT

func pickable_effect(pickable):
	if pickable == "INGOT":
		health_controller.heal()
	elif pickable == "WAVE":
		var limit = 0
		while true:
			waveCollider.scale +=Vector2(2.5,2.5)
			limit +=1
			await get_tree().create_timer(0.00001).timeout
			if limit > 50:
				limit = 0
				waveCollider.scale = Vector2.ONE
				break
	elif pickable == "SHOCK":
		arena.hud.set_item_ui("SHOCK")
		for i in arena.mob_container.get_children():
			i.state = i.ENEMY_STATES.PARALYZED
	elif pickable == "DEATH":
		var limit = 0
		while true:
			death_wave = true
			waveCollider.scale +=Vector2(2.5,2.5)
			limit +=1
			await get_tree().create_timer(0.00001).timeout
			if limit > 50:
				death_wave = false
				limit = 0
				waveCollider.scale = Vector2.ONE
				break
	elif pickable == "UNCAP":
		cd_cap = 0.1
		arena.hud.set_item_ui("UNCAP")
		await get_tree().create_timer(5).timeout
		cd_cap = 0.5


func _on_wave_area_area_entered(area):
	if !death_wave:
		area.get_parent().recoil_pos = global_position
		area.get_parent().state = area.get_parent().ENEMY_STATES.RECOIL
	else:
		area.get_parent().queue_free()
