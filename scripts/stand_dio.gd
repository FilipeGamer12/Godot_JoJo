extends CharacterBody2D

@onready var damage = $DamageE1
@onready var theWorld_anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var enemy_1 = $"Boss" or $"Enemy3"

signal animation_finished

const SPEED = 0.0
const OFFSET = 10.0

enum StandState {
	idle,
	attack
}

var status: StandState = StandState.idle
var current_attack: String = ""
var can_deal_damage: bool = false

func _ready():
	randomize()

func _physics_process(delta: float) -> void:
	if enemy_1 == null or status == StandState.attack:
		return

	var target_x: float = enemy_1.position.x + OFFSET
	if abs(position.x - target_x) > 1.0:
		position.x = move_toward(position.x, target_x, SPEED * delta)
	else:
		position.x = target_x

	match status:
		StandState.idle:
			idle_state()
		StandState.attack:
			attack_state()

func go_to_idle_state():
	status = StandState.idle
	current_attack = ""
	theWorld_anim.play("idle")
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
	pass

func attack_state():
	match current_attack:
		"barrage":
			can_deal_damage = theWorld_anim.frame >= 2 and theWorld_anim.frame <= 6
			print("dano DIO")
		"kick":
			can_deal_damage = theWorld_anim.frame >= 3 and theWorld_anim.frame <= 5
			print("dano DIO")
		"punch":
			can_deal_damage = theWorld_anim.frame >= 2 and theWorld_anim.frame <= 4
			print("dano DIO")
		_:
			can_deal_damage = false


func _on_animated_sprite_2d_animation_finished():
	if theWorld_anim.animation == current_attack:
		go_to_idle_state()
		emit_signal("animation_finished")
