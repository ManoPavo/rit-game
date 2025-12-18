extends CanvasLayer

@onready var som = $AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Gameover.modulate.a = 0
	self.visible = true
	Transicao.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var tween = get_tree().create_tween()
	if self.visible:
		tween.tween_property($ColorRect, "modulate:v", 0 , 0.15 )
		get_tree().create_timer(5).timeout
		tween.tween_property($Gameover, "modulate:a", 2, 30 )
	else:
		tween.tween_property($ColorRect, "modulate:v", 100, 0.1)
		
	if Input.is_anything_pressed():
		await get_tree().create_timer(4).timeout
		Transicao.visible = true
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://escolha_lvl.tscn")
		
		
