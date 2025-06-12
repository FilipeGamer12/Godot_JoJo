extends Node2D

@onready var boss = $Boss
@onready var barreira = $barreira_end
@onready var tween = create_tween()

func _ready():
	if boss:
		boss.tree_exited.connect(_on_boss_destruido)

func _on_boss_destruido():
	print("Boss foi destruído! Subindo barreira.")

	var destino = barreira.position - Vector2(0, 200)
	tween = get_tree().create_tween()
	tween.tween_property(barreira, "position", destino, 1.0)
	tween.tween_callback(Callable(barreira, "queue_free"))
