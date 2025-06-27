extends CharacterBody2D

@export var speed = 50.0
const gravity = 9  

var direction = 1

@onready var ground_detector = $GroundDetector
@onready var sprite = $Sprite2D

func _ready():
	# Configurar el RayCast2D para detectar suelo
	ground_detector.position.x = 16  
	ground_detector.target_position = Vector2(0, 20)
	ground_detector.enabled = true
	
	# Configurar layer de colisión para detección del player
	collision_layer = 2
	
	# Conectar señal del Area2D si existe
	if has_node("Area2D"):
		$Area2D.body_entered.connect(_on_area_2d_body_entered)

func _physics_process(delta):
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravity
	
	# Movimiento horizontal
	velocity.x = direction * speed
	
	# Detectar borde del terreno
	if is_on_floor() and not ground_detector.is_colliding():
		direction *= -1
		sprite.scale.x *= -1  # Voltear sprite
		ground_detector.position.x *= -1  # Voltear detector
	
	move_and_slide()

func eliminate():
	# Método llamado por el player al saltar encima
	queue_free()

# Detectar colisión lateral con jugador
func _on_area_2d_body_entered(body):
	if body.has_method("take_damage"):
		# Solo hacer daño si el player no está invulnerable
		if not body.invulnerable:
			body.take_damage()
