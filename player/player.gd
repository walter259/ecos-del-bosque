extends CharacterBody2D

var speed := 120
var direccion := 0.0
var jump := 250
const gravity := 9

@onready var anim := $AnimationPlayer
@onready var sprite := $Sprite2D
func _physics_process(delta):
	direccion = Input.get_axis("ui_left" ,"ui_right")
	velocity.x = direccion * speed
	
	if direccion != 0:
		anim.play("Run")
	else:
		anim.play("idle")
		
	sprite.flip_h = direccion < 0 if direccion != 0 else sprite.flip_h
		
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y -=jump
		
	if !is_on_floor():
		velocity.y += gravity
		
	if position.y > 900:
		get_tree().change_scene_to_file("res://scenes/retry.tscn")
		
	move_and_slide()
