extends Node2D

@onready var but1 = $PlayButton
@onready var but2 = $PlayButton2
@onready var but3 = $PlayButton3

# Called when the node enters the scene tree for the first time.
func _ready():
	but1.position.y = 1000
	but2.position.y = 1000
	but3.position.y = 1000
	var tween = get_tree().create_tween()
	tween.tween_property(but1, "position:y", 102, 1)
	tween.tween_property(but2, "position:y", 102, 1)
	tween.tween_property(but3, "position:y", 102, 1)
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_2_pressed():
	get_tree().change_scene_to_file("res://node_2d.tscn")# Replace with function body.
