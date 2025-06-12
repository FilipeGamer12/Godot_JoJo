extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 120.0
const JUMP_VELOCITY = -330.0

@export var max_jump_count = 2

var jump_count = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else: 
		jump_count = 0
		if velocity.x != 0:
			anim.play("running")
		else:
			anim.play("idle")

	# Handle jump.
	if Input.is_action_just_pressed("jump") and jump_count < max_jump_count:
		jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if velocity.x > 0:
		anim.flip_h = false
	elif velocity.x < 0:
		anim.flip_h = true
		
	move_and_slide()
	
func jump():
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		anim.play("jump")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("DeathZone"):
		print("e morreu")
		call_deferred("REreload_scene")
	elif area.is_in_group("LevelEnd"):
		var next_level = area.next_level
		if next_level:
			call_deferred("load_scene", next_level)
		else:
			push_error("Next level not found or defined")
	elif area.is_in_group("Enemies"):
		if velocity.y > 0:
			print("dale Coxa!")
			area.take_damage()
			jump()
		else:
			print("te mataram")
			call_deferred("REreload_scene")

func reload_scene():
	get_tree().reload_current_scene()
func load_scene(scene_name: String):
	get_tree().change_scene_to_file("res://cena/" + scene_name + ".tscn")
func REreload_scene():
	get_tree().change_scene_to_file("res://cena/game_over.tscn")
