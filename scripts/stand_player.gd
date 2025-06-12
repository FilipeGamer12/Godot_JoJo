extends CharacterBody2D
@onready var star_anim: AnimatedSprite2D = $Star_anim_idle
@onready var damage: Area2D = $Damage
@onready var damage2 = $Damage2
@onready var damage3 = $Damage3

const SPEED = 60.0

var player: CharacterBody2D
var status: StandState

enum StandState {
	idle,
	light_punch,
	punch,
	heavy_punch
}

var is_flipped = false

func _physics_process(delta: float) -> void:
	if is_flipped:
		position.x = move_toward(position.x, player.position.x + 10, SPEED * delta)
		position.y = move_toward(position.y, player.position.y, 1 + SPEED * delta)
	else:
		position.x = move_toward(position.x, player.position.x - 10, SPEED * delta)
		position.y = move_toward(position.y, player.position.y, 1 + SPEED * delta)
	
	match status:
		StandState.idle:
			idle_state()
		StandState.light_punch:
			light_punch()
		StandState.punch:
			punch()
		StandState.heavy_punch:
			heavy_punch()

func inverter(flip):
	if flip:
		scale.x = -1
	else:
		scale.x = 1
	#star_anim.flip_h = flip
	is_flipped = flip

## MÁQUINA DE ESTADOS

func go_to_idle_state():
	status = StandState.idle
	star_anim.play("idle_stand")
	z_index = -1

func go_to_light_punch_state():
	status = StandState.light_punch
	star_anim.play("light_punch")
	z_index = 4

func go_to_punch_state():
	status = StandState.punch
	star_anim.play("punch")
	z_index = 4

func go_to_heavy_punch_state():
	status = StandState.heavy_punch
	star_anim.play("heavy_punch")
	z_index = 4

func idle_state():
	if Input.is_action_just_pressed("punch"):
		go_to_punch_state()
		return
	if Input.is_action_just_pressed("light_punch"):
		go_to_light_punch_state()
		return
	if Input.is_action_just_pressed("heavy_punch"):
		go_to_heavy_punch_state()
		return

func light_punch():
	pass
	if star_anim.frame == 5:
		damage2.process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		damage2.process_mode = Node.PROCESS_MODE_DISABLED
		
func punch():
	pass
	if star_anim.frame == 0:
		damage.process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		damage.process_mode = Node.PROCESS_MODE_DISABLED
func heavy_punch():
	pass
	if star_anim.frame == 3:
		damage3.process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		damage3.process_mode = Node.PROCESS_MODE_DISABLED

func _on_star_anim_idle_animation_finished() -> void:
	if star_anim.animation == "punch":
		go_to_idle_state()
	if star_anim.animation == "light_punch":
		go_to_idle_state()
	if star_anim.animation == "heavy_punch":
		go_to_idle_state()

func _on_damage_area_entered(area: Area2D) -> void:
	print("hit")

func _on_damage_2_area_entered(area):
	print("hit2")

func _on_damage_3_area_entered(area):
	print("hit3")
