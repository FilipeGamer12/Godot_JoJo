extends Node2D

func _ready():
	$AudioStreamPlayer2D.play()
	$AudioStreamPlayer2D.stream.loop = true
