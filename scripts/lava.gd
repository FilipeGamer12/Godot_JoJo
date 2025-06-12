extends TileMapLayer

@export var speed: float

func _physics_process(delta: float) -> void:
	position.y += -speed * delta
