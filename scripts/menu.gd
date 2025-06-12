extends Node2D


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/fase_1.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func _ready():
	$AudioStreamPlayer2D.play()
	$AudioStreamPlayer2D.stream.loop = true
