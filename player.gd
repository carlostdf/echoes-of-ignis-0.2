extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

var velocidad = 200
var atacando = false
var ultima_direccion = "down"

func _ready():
	anim.animation_finished.connect(_on_animation_finished)

func _physics_process(delta):
	var direccion = Vector2.ZERO

	if Input.is_action_just_pressed("ui_accept") and not atacando:
		atacar()
		return

	if atacando:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if Input.is_action_pressed("ui_right"):
		direccion.x += 1
	if Input.is_action_pressed("ui_left"):
		direccion.x -= 1
	if Input.is_action_pressed("ui_down"):
		direccion.y += 1
	if Input.is_action_pressed("ui_up"):
		direccion.y -= 1

	velocity = direccion.normalized() * velocidad
	move_and_slide()

	if direccion == Vector2.ZERO:
		if anim.animation != "idle_down":
			anim.play("idle_down")
	else:
		if direccion.x > 0:
			ultima_direccion = "right"
			anim.flip_h = false
			anim.play("walk_right")

		elif direccion.x < 0:
			ultima_direccion = "left"
			anim.flip_h = true
			anim.play("walk_right") # misma animación espejada

		elif direccion.y > 0:
			ultima_direccion = "down"
			anim.flip_h = false
			anim.play("walk_down")

		elif direccion.y < 0:
			ultima_direccion = "up"
			anim.flip_h = false
			anim.play("walk_up")

func atacar():
	atacando = true
	velocity = Vector2.ZERO

	if ultima_direccion == "left":
		anim.flip_h = true
		anim.play("attack_right") # ataque común espejado
	elif ultima_direccion == "right":
		anim.flip_h = false
		anim.play("attack_right")
	else:
		anim.flip_h = false
		anim.play("attack_down")

func _on_animation_finished():
	if anim.animation == "attack_down" or anim.animation == "attack_right":
		atacando = false
		anim.flip_h = false
		anim.play("idle_down")
