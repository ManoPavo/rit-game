extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.position.y = 600
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", -60, 1)
	await get_tree().create_timer(1).timeout
	
	anima()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func anima():
	var tween = get_tree().create_tween().set_loops()
	
	tween.tween_property(self, "position:y", -90, 0.7).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2(0.6, 0.6), 0.2)
	
	tween.tween_property(self, "scale", Vector2(0.5, 0.5), 0.2)
	tween.tween_property(self, "position:y", -60, 0.7).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	
	
	
