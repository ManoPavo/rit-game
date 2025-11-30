extends CanvasLayer

@onready var tela_preta = $ColorRect

func _ready() -> void:
	pass
	
	
	
	
func _process(delta: float) -> void:
	var tween = get_tree().create_tween()
	if Transicao.visible:
		tween.tween_property(tela_preta, "position:x", 1200, 2)
	else:
		tween.tween_property(tela_preta, "position:x", -3000, 2)
		
