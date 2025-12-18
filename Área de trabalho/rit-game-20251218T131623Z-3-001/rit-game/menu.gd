extends Node2D

@onready var play_button = $PlayButton
@onready var options_button = $OptionsButton
@onready var exit_button = $ExitButton




func _ready():
	play_button.position = Vector2(150, 300)
	options_button.position = Vector2(150, 300)
	exit_button.position = Vector2(150, 300)
	_animate_single_button()
	await get_tree().create_timer(4.5).timeout
	Transicao.visible = false

func _animate_single_button():
	var tween = get_tree().create_tween()
	
	tween.tween_property(play_button, "position:y", 50 ,0.9).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(options_button, "position:y", 120 ,0.9).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(exit_button, "position:y", 190 ,0.9).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	

# Função para adicionar hover effect nos botões
func _on_button_mouse_entered(button: Button):
	var tween = get_tree().create_tween()
	tween.tween_property(button, "scale", Vector2(1.05, 1.05), 0.2)\
		.set_ease(Tween.EASE_OUT)

func _on_button_mouse_exited(button: Button):
	var tween = get_tree().create_tween()
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.2)\
		.set_ease(Tween.EASE_OUT)


func _on_play_button_pressed() -> void:
	Transicao.visible = true
	get_tree().change_scene_to_file("res://escolha_lvl.tscn")


func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	get_tree().quit()
