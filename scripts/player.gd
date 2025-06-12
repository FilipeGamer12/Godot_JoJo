extends CharacterBody2D

@onready var animIdle: AnimatedSprite2D = $Idle
@onready var animRunning: AnimatedSprite2D = $Running
@onready var damageP = $DamageP
@onready var hitbox = $hitbox

const SPEED = 60.0
const JUMP_VELOCITY = -330.0
@export var max_jump_count = 2
const STAND_PLAYER = preload("res://entitites/stand_player.tscn")
var jump_count = 0
var stand: CharacterBody2D
var health = 12
var counter_cooldown := 0.0

enum PlayerState {
	idle,
	walk,
	jump,
	counter,
	damage
}

var status: PlayerState


func _ready() -> void:
	go_to_idle_state()

func _physics_process(delta: float) -> void:
	counter_cooldown = max(0, counter_cooldown - delta)

	if Input.is_action_just_pressed("stand"):
		if stand == null:
			stand = STAND_PLAYER.instantiate()
			stand.position = position
			stand.player = self
			add_sibling(stand)
		else:
			stand.queue_free()

	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_floor():
		jump_count = 0

	if Input.is_action_just_pressed("punch") and stand:
		stand.punch()
	if Input.is_action_just_pressed("light_punch") and stand:
		stand.light_punch()
	if Input.is_action_just_pressed("heavy_punch") and stand:
		stand.heavy_punch()

	match status:
		PlayerState.idle:
			idle_state()
		PlayerState.walk:
			walk_state()
		PlayerState.jump:
			jump_state()
		PlayerState.counter:
			counter()
		PlayerState.damage:
			damage_state()

	move_and_slide()

## MÁQUINA DE ESTADOS

func go_to_idle_state():
	status = PlayerState.idle
	animIdle.play("idle")

func go_to_walk_state():
	status = PlayerState.walk
	animIdle.play("walking")

func go_to_jump_state():
	status = PlayerState.jump
	animIdle.play("jump")

func go_to_counter_state():
	status = PlayerState.counter
	animIdle.play("counter")

func go_to_damage_state():
	status = PlayerState.damage
	animIdle.play("damage")
	velocity.x = 0

func counter():
	if animIdle.frame == 3:
		damageP.process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		damageP.process_mode = Node.PROCESS_MODE_DISABLED

func idle_state():
	move()
	if velocity.x != 0:
		go_to_walk_state()
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
	if Input.is_action_just_pressed("counter") and counter_cooldown <= 0.0:
		go_to_counter_state()
		counter_cooldown = 2.0

func walk_state():
	move()
	if velocity.x == 0:
		go_to_idle_state()
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()

func jump_state():
	move()
	if is_on_floor():
		if velocity.x != 0:
			go_to_walk_state()
		else:
			go_to_idle_state()

func damage_state():
	if health <= 0:
		REreload_scene()
		return

	if animIdle.animation != "damage" or not animIdle.is_playing():
		animIdle.play("damage")

	var ainda_em_dano = false
	for area in $hitbox.get_overlapping_areas():
		if area.is_in_group("enemy1_attack") or area.is_in_group("enemy2_attack"):
			ainda_em_dano = true
			break

	if Input.is_action_just_pressed("counter") and counter_cooldown <= 0.0:
		go_to_counter_state()
		counter_cooldown = 2.0
	elif not ainda_em_dano:
		go_to_idle_state()

## MOVIMENTAÇÃO

func move():
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if velocity.x > 0:
		animIdle.flip_h = false
		damageP.scale.x = 1
		if stand:
			stand.inverter(false)
	elif velocity.x < 0:
		animIdle.flip_h = true
		damageP.scale.x = -1
		if stand:
			stand.inverter(true)

	if Input.is_action_just_pressed("jump") and jump_count < max_jump_count:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		go_to_jump_state()

func _on_death_zone_area_entered(area):
	print("e morreu")
	call_deferred("REreload_scene")

func REreload_scene():
	get_tree().change_scene_to_file("res://scenes/gameOver.tscn")

func _on_hitbox_area_entered(area):
	if area.is_in_group("enemy2_attack"):
		if status != PlayerState.damage:
			print("Player tomou dano!")
			health -= 1
			print(health)
			go_to_damage_state()
	if area.is_in_group("enemy1_attack"):
		if status != PlayerState.damage:
			print("Player tomou dano!")
			health -= 2
			print(health)
			go_to_damage_state()

func _on_idle_animation_finished():
	if animIdle.animation == "counter":
		go_to_idle_state()
