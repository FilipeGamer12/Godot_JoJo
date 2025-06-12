extends CharacterBody2D
var speed = 50.0

enum EnemyState {
	andando, 
	atacando, 
	morto
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var timer: Timer = $Timer
@onready var det_chão: RayCast2D = $"Detector de chão"
@onready var det_player: RayCast2D = $"Detector de Player"
@onready var attack_area: Area2D = $Temp_Attack_Area

var status: EnemyState

var direction = 1 

func _ready() -> void:
	ir_para_andando()

func _physics_process(delta: float) -> void:
	
	match status:
		EnemyState.andando:
			andando()
		EnemyState.atacando:
			atacando()
		EnemyState.morto:
			morto()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func ir_para_andando():
	status = EnemyState.andando
	anim.play("walk")
	
func andando():
	if not det_chão.is_colliding():
		direction *= -1
		scale.x *= -1
	velocity.x = speed * direction
	if det_player.is_colliding():
		ir_para_atacando()

func ir_para_atacando():
	status = EnemyState.atacando
	velocity.x = 0
	anim.play("attack")
	
func atacando():
	if anim.frame != 0:
		attack_area.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		attack_area.process_mode = Node.PROCESS_MODE_DISABLED
	
func ir_para_morto():
	status = EnemyState.morto
	velocity.x = 0
	
func morto():
	take_damage()
	pass
	 
func take_damage():
	print("danou-se")
	direction = 0
	anim.play("morto")
	hitbox.queue_free()
	timer.start()
	jump()
	collision_mask = 0

func _on_timer_timeout() -> void:
	queue_free()

func jump():
	velocity.y = -170


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "attack":
		ir_para_andando()
