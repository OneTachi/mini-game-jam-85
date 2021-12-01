extends AnimatedSprite


func _ready():
	play("default")


func _on_SlashEffect_animation_finished():
	queue_free()
