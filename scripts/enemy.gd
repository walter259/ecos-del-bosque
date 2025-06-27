extends CharacterBody2D

@export var speed = 50.0
const gravity = 9  

var direction = 1

@onready var ground_detector = $GroundDetector
@onready var sprite = $Sprite2D

func _ready():
	ground_detector.position.x = 16  
	ground_detector.target_position = Vector2(0, 20)
	ground_detector.enabled = true
	
	
	collision_layer = 2

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity
	
	
	velocity.x = direction * speed
	

	if is_on_floor() and not ground_detector.is_colliding():
		direction *= -1
		sprite.scale.x *= -1  
		ground_detector.position.x *= -1  
	
	move_and_slide()

func eliminate():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.has_method("take_damage"):
		var player_pos = body.global_position
		var enemy_pos = global_position
		
		if player_pos.y >= enemy_pos.y - 5:  
			body.take_damage()
