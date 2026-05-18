extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

const SPEED = 60.0
const GRAVITY = 900.0

var direccion = -1
var vida = 1

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	velocity.x = direccion * SPEED

	move_and_slide()

	if anim:
		anim.play("walk")

func recibir_daño():
	vida -= 1
	
	if vida <= 0:
		morir()

func morir():
	queue_free()
