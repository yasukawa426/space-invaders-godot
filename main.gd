extends Node2D
@onready var packed_enemy: PackedScene = preload("res://entities/enemies/enemy.tscn")
@export var ENTITIES_SCALING: float = 0.6

var current_score: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player/Player.position= $Player/PlayerStartingPosition.position
	$Enemies/Formation.position = $Enemies/FormationStartingPosition.position
	for entity in get_tree().get_nodes_in_group("scalable_entites"):
		entity.scale = Vector2.ONE * ENTITIES_SCALING

func _process(_delta: float) -> void:
	# This is just a visual effect to make the earth and shield look a little more alive. It makes them scale up and down horizontally subtly
	# We use the the amount of time passed since the game started multiplied by a veeery small number to get a increasing value and then use the sine of that value to scale them between 1.0 and 1.2.
	var t := Time.get_ticks_msec() * 0.00004
	var scale_value = 1.1 + sin(t) * 0.1
	$Earth.scale.x = scale_value
	$Shield.scale.x = scale_value

## Enemy died, increase score
func _on_grid_formation_enemy_died(score: int, _alive_enemies: int) -> void:
	print("Enemy just died. Score: ", score)
	current_score += score
