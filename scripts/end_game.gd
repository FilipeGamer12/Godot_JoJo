extends Node2D


func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/fase_1.tscn")


func _on_back_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _ready():
	$AudioStreamPlayer2D.play()
	$AudioStreamPlayer2D.stream.loop = true
