extends CharacterBody2D

var speed := 120
var direccion := 0.0
var jump := 250
const gravity := 9

@onready var anim := $AnimationPlayer
@onready var sprite := $Sprite2D

func _physics_process(delta):
	direccion = Input.get_axis("ui_left", "ui_right")
	velocity.x = direccion * speed
	
	if direccion != 0:
		anim.play("Run")
	else:
		anim.play("idle")
		
	sprite.flip_h = direccion < 0 if direccion != 0 else sprite.flip_h
		
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y -= jump
		
	
	if velocity.y > 0:  # Cayendo
		check_enemy_below()
		
	if !is_on_floor():
		velocity.y += gravity
		
	if position.y > 900:
		get_tree().change_scene_to_file("res://scenes/retry.tscn")
		
	move_and_slide()

func check_enemy_below():
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		global_position, 
		global_position + Vector2(0, 30)
	)
	query.collision_mask = 2  
	
	var result = space_state.intersect_ray(query)
	if result and result.collider.has_method("eliminate"):
		result.collider.eliminate()
		velocity.y = -jump * 0.8  # Rebote al eliminar enemigo
