extends CharacterBody2D

var speed = 30.0

enum EnemyState {
	andando, 
	atacando, 
	takeDamage
}

var health = 5
var attack: String
var invulneravel := false

@onready var stand = $Stand_Pucci
@onready var anim: AnimatedSprite2D = $Idle
@onready var hitbox: Area2D = $Hitbox
@onready var det_chão: RayCast2D = $"Detector de chão"
@onready var det_player: RayCast2D = $"Detector de Player"
@onready var det_parede: RayCast2D = $"Detector de parede"
@onready var stand_pucci = $Stand_Pucci
@onready var colisor = $Colisor

var status: EnemyState
var direction := 1
var last_direction := direction

var attack_cooldown := 0.0

func _ready() -> void:
	ir_para_andando()

func _physics_process(delta: float) -> void:
	match status:
		EnemyState.andando:
			andando()
		EnemyState.atacando:
			atacando()
		EnemyState.takeDamage:
			take_damage()

	attack_cooldown = max(0, attack_cooldown - delta)

	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func ir_para_andando():
	status = EnemyState.andando
	anim.play("walk")

func andando():
	if attack != "":
		ir_para_take_damage()
		return

	if det_player.is_colliding() and attack_cooldown <= 0.0:
		ir_para_atacando()
		return

	if not det_chão.is_colliding() or det_parede.is_colliding():
		direction *= -1
		scale.x *= -1
		last_direction = direction

	velocity.x = speed * direction

func ir_para_atacando():
	velocity.x = 0
	anim.play("idle")
	status = EnemyState.atacando

func atacando():
	velocity.x = 0
	if stand != null:
		stand.go_to_punch_state()
	attack_cooldown = 1.0
	await stand.animation_finished
	ir_para_andando()

func ir_para_take_damage():
	velocity.x = 0
	stand.whiteSnake_anim.play("idle")
	status = EnemyState.takeDamage

func take_damage():
	if health <= 0:
		anim.play("death")
		stand.visible = false
		await get_tree().create_timer(0.2).timeout
		jump()
	else:
		stand.z_index = -2
		anim.play("damage")
		if attack == "light":
			health -= 1
			print("light2")
		elif attack == "normal":
			health -= 2
			print("normal2")
		elif attack == "heavy":
			health -= 3
			print("heavy2")
		else:
			return
	attack = ""
	#print("Vida pucci: " + str(health))

func jump():
	velocity.y = -150

func _on_hitbox_area_entered(area):
	if invulneravel:
		return

	if area.is_in_group("light_attack"):
		attack = "light"
		print("light")
	elif area.is_in_group("normal_attack"):
		attack = "normal"
		print("normal")
	elif area.is_in_group("heavy_attack"):
		attack = "heavy"
		print("heavy")
	else:
		return

	invulneravel = true
	ir_para_take_damage()
	await get_tree().create_timer(0.2).timeout
	invulneravel = false

func _on_idle_animation_finished():
	if anim.animation == "attack":
		ir_para_andando()
	if anim.animation == "damage":
		ir_para_andando()
	if anim.animation == "death":
		queue_free()
