extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.position.y = 600
	$".".play("default")
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", -125, 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
