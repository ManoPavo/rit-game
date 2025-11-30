extends Node2D

@onready var logo = $Logo
@onready var title = $Title


func _ready():
	
	
	logo.position = Vector2(-1000, 0)
	logo.scale = Vector2(0.5, 0.5)
	title.scale = Vector2(1.0, 1.0)
	
	intro_animation()


func intro_animation():
	var tween = get_tree().create_tween()
	
	tween.tween_property(logo, "position:x", 0 ,0.9).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(logo, "scale", Vector2(0.6, 0.6), 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_interval(0.1)
	
	tween.tween_property(logo, "scale", Vector2(0.8, 0.8), 0.25)
	tween.tween_property(logo, "scale", Vector2(0.7, 0.7), 0.25)
	tween.tween_property(logo, "scale", Vector2(0.9, 0.9), 0.25)
	
	tween.tween_interval(0.3)
	
	tween.tween_property(logo, "modulate:a", 0.0, 1.0)
	tween.tween_property(title, "modulate:a", 0.0, 1.2)
	
	
	tween.tween_callback(_go_to_menu)


func _go_to_menu():
	
	Transicao.visible = true
	get_tree().change_scene_to_file("res://menu.tscn")
	
	
	
