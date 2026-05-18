extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

# CAMBIADO: antes decía $AttackArea
@onready var attack_area: Area2D = $HitboxAtaque

# CAMBIADO: antes decía $AttackArea/CollisionShape2D
@onready var attack_collision: CollisionShape2D = $HitboxAtaque/CollisionShape2D

const SPEED := 160.0
const JUMP_FORCE := -360.0
const GRAVITY := 900.0

var atacando := false
var direccion := 1

func _ready():
	attack_collision.disabled = true
	anim.animation_finished.connect(_on_animation_finished)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if atacando:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
		return

	var input_dir := Input.get_axis("ui_left", "ui_right")

	if input_dir != 0:
		velocity.x = input_dir * SPEED
		direccion = sign(input_dir)
		anim.flip_h = direccion < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE

	if Input.is_action_just_pressed("attack"):
		atacar()

	actualizar_animacion(input_dir)

	move_and_slide()

func actualizar_animacion(input_dir):
	if atacando:
		return
	if not is_on_floor():
		if velocity.y < 0:
			anim.play("jump")
		else:
			anim.play("fall")
	elif input_dir != 0:
		anim.play("run")
	else:
		anim.play("idle")

func atacar():
	if atacando:
		return
	atacando = true
	velocity.x = 0
	anim.stop()
	anim.play("attack")
	attack_collision.disabled = false
	if direccion > 0:
		attack_area.position.x = abs(attack_area.position.x)
	else:
		attack_area.position.x = -abs(attack_area.position.x)

func _on_animation_finished():
	print("animación terminó: ", anim.animation)
	if anim.animation == "attack":
		atacando = false
		attack_collision.disabled = true
		
func _on_hitboxataque_body_entered(body):
	print("algo entró al hitbox: ", body.name)
	if body.has_method("recibir_daño"):
		print("tiene el método, aplicando daño")
		body.recibir_daño()
