extends TileMapLayer

@export var speed: float

func _physics_process(delta: float) -> void:
	if position.y <= -390:
		return
	position.y += -speed * delta
