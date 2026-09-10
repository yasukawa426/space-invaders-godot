extends Node2D
@onready var packed_enemy: PackedScene = preload("res://entities/enemies/enemy.tscn")
@onready var formation: Node = $Entities/GridFormation
@export var ENTITIES_SCALING: float = 0.6

var current_score: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Entities/Player.position= $Entities/PlayerStartingPosition.position
	$Entities/GridFormation.position = $Entities/FormationStartingPosition.position
	for entity in $Entities.get_children():
		entity.scale = Vector2.ONE * ENTITIES_SCALING


## Enemy died, increase score
func _on_grid_formation_enemy_died(score: int) -> void:
	print("Enemy just died. Score: ", score)
	current_score += score
