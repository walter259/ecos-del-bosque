extends Area2D

@export var next_scene: String = "res://scenes/level_2.tscn"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":  
		get_tree().change_scene_to_file(next_scene)
