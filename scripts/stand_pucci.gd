extends CharacterBody2D

@onready var damage = $DamageE2
@onready var whiteSnake_anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var enemy_2 = $"Enemy2"

signal animation_finished

const SPEED = 00.0
const OFFSET = 10.0

enum StandState {
	idle,
	punch
}

var status: StandState = StandState.idle

func _physics_process(delta: float) -> void:
	if enemy_2 == null or status == StandState.punch:
		return

	var target_x: float = enemy_2.position.x + OFFSET

	if abs(position.x - target_x) > 1.0:
		position.x = move_toward(position.x, target_x, SPEED * delta)
	else:
		position.x = target_x

	match status:
		StandState.idle:
			idle_state()
		StandState.punch:
			punch()

func go_to_idle_state():
	status = StandState.idle
	whiteSnake_anim.play("idle")

func go_to_punch_state():
	status = StandState.punch
	whiteSnake_anim.play("attack")
	punch()

func idle_state():
	pass

func punch():
	if whiteSnake_anim.frame >= 2 and whiteSnake_anim.frame <= 13:
		damage.process_mode = Node.PROCESS_MODE_ALWAYS
		#print("dano PUCCI ativo")
	else:
		damage.process_mode = Node.PROCESS_MODE_DISABLED
		#print("dano PUCCI não ativo")
	z_index = 3

func _on_whiteSnake_anim_idle_animation_finished() -> void:
	if whiteSnake_anim.animation == "attack":
		go_to_idle_state()
		emit_signal("animation_finished")
		z_index = -2

func _on_damage_area_entered(area: Area2D) -> void:
	print("hit")
