extends CharacterBody2D
@onready var hitbox: Area2D = $Hitbox
@onready var anim_dummy: AnimatedSprite2D = $AnimatedSprite2D

var health = 100

signal died(position: Vector2)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("light_attack"):
		health -= 1
		print("light")
	elif area.is_in_group("normal_attack"):
		health -= 2
		print("normal")
	elif area.is_in_group("heavy_attack"):
		health -= 3
		print("heavy")
	anim_dummy.play("damage")
	
	if health <= 0:
		anim_dummy.play("died")
		await get_tree().create_timer(0.6).timeout
		emit_signal("died", global_position)
		queue_free()


func _on_animated_sprite_2d_animation_finished():
	if anim_dummy.animation == "damage":
		anim_dummy.play("idle")
