extends CharacterBody2D

@onready var theWorld_anim = $theWorld_anim
@onready var enemy_3 = $".."
@onready var dano = $DamageE1

signal animation_finished

const SPEED = 0.0
const OFFSET = 10.0

enum StandState {
	idle,
	attack
}

var current_attack: String = ""
var status: StandState = StandState.idle

func _physics_process(delta: float) -> void:
	if enemy_3 == null:
		return

	var target_x: float = enemy_3.position.x + OFFSET

	if abs(position.x - target_x) > 1.0:
		position.x = move_toward(position.x, target_x, SPEED * delta)
	else:
		position.x = target_x

	match status:
		StandState.idle:
			idle_state()
		StandState.attack:
			attack()  # <- chamado a cada frame agora

func go_to_idle_state():
	status = StandState.idle
	theWorld_anim.play("idle")
	current_attack = ""
	dano.process_mode = Node.PROCESS_MODE_DISABLED
	z_index = -2

func go_to_attack_state():
	if status == StandState.attack:
		return
	status = StandState.attack
	var attacks = ["barrage", "kick", "punch"]
	current_attack = attacks[randi() % attacks.size()]
	theWorld_anim.play(current_attack)
	z_index = 3

func idle_state():
	#print(dano.process_mode)
	pass

func attack():
	if current_attack == "barrage":
		if theWorld_anim.frame >= 2 and theWorld_anim.frame <= 11:
			dano.process_mode = Node.PROCESS_MODE_ALWAYS
			#print("dano DIO ativo")
		else:
			dano.process_mode = Node.PROCESS_MODE_DISABLED
			#print("dano DIO não ativo")
	elif current_attack == "kick":
		if theWorld_anim.frame >= 3 and theWorld_anim.frame <= 5:
			dano.process_mode = Node.PROCESS_MODE_ALWAYS
			#print("dano DIO ativo")
		else:
			dano.process_mode = Node.PROCESS_MODE_DISABLED
			#print("dano DIO não ativo")
	elif current_attack == "punch":
		if theWorld_anim.frame >= 2 and theWorld_anim.frame <= 4:
			dano.process_mode = Node.PROCESS_MODE_ALWAYS
			#print("dano DIO ativo")
		else:
			dano.process_mode = Node.PROCESS_MODE_DISABLED
			#print("dano DIO não ativo")

func _on_the_world_anim_animation_finished():
	if theWorld_anim.animation in ["barrage", "kick", "punch"]:
		go_to_idle_state()
		emit_signal("animation_finished")
