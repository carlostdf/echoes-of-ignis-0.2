extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var floor_ray: RayCast2D = $FloorRay
@onready var wall_ray: RayCast2D = $WallRay

const SPEED := 60.0
const GRAVITY := 900.0
const COOLDOWN_CAMBIO := 0.5

var direccion := -1
var vida := 1
var tiempo_cambio := 0.0

func _physics_process(delta):
	tiempo_cambio -= delta
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	velocity.x = direccion * SPEED
	if is_on_floor() and tiempo_cambio <= 0:
		if not floor_ray.is_colliding() or wall_ray.is_colliding():
			cambiar_direccion()
	anim.play("walk")
	move_and_slide()

func cambiar_direccion():
	direccion *= -1
	anim.flip_h = direccion > 0
	floor_ray.position.x *= -1
	wall_ray.target_position.x *= -1
	tiempo_cambio = COOLDOWN_CAMBIO

func recibir_daño():
	vida -= 1
	if vida <= 0:
		morir()

func morir():
	queue_free()
