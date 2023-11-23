extends Control

@onready var health_ui = $LifeUI
@onready var reload_ui = $ReloadUI
@onready var paralysis_ui = $ParalysisUI
@onready var uncap_ui = $UncapUI

func _ready():
	reload_ui.value = 100
	paralysis_ui.value = 0
	uncap_ui.value = 0

func set_time_label(value):
	$TimerLabel.text = "TIME: " + str(value)

func set_reload_ui(value):
	reload_ui.value = 0
	var await_time = value / 100
	for i in 100:
		reload_ui.value += 1
		await get_tree().create_timer(await_time).timeout

func set_item_ui(item):
	if item == "SHOCK":
		paralysis_ui.value = 100
		for i in 100:
			paralysis_ui.value -= 1
			await get_tree().create_timer(0.05).timeout
	if item == "UNCAP":
		uncap_ui.value = 100
		for i in 100:
			uncap_ui.value -= 1
			await get_tree().create_timer(0.05).timeout

func set_health_ui(value):
	
	if value == 3:
		health_ui.get_node("Life1").modulate.a = 255
		health_ui.get_node("Life2").modulate.a = 255
		health_ui.get_node("Life3").modulate.a = 255
	if value == 2:
		health_ui.get_node("Life1").modulate.a = 255
		health_ui.get_node("Life2").modulate.a = 255
		health_ui.get_node("Life3").modulate.a = 0
	if value == 1:
		health_ui.get_node("Life1").modulate.a = 255
		health_ui.get_node("Life2").modulate.a = 0
		health_ui.get_node("Life3").modulate.a = 0
	if value == 0:
		health_ui.get_node("Life1").modulate.a = 0
		health_ui.get_node("Life2").modulate.a = 0
		health_ui.get_node("Life3").modulate.a = 0
