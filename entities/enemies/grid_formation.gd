## This creates and moves a grid formations of enemies. 
## The enemies start on the first 5 rows of the screen, and they move downwards as the game progresses, having in total 10 rows.
## The enemies first go to the edge of the screen, then they move downwards and go to the other edge of the screen, repeating this process until they reach the bottom of the screen (Earth).
class_name Formation extends Node2D

signal enemy_died(score: int)

## Vertical spacing between enemies. Enemies sprites are 16x16, so we add 16 to the spacing to avoid overlapping.
const VERTICAL_SPACING: int = 15 + 16
## Horizontal spacing between enemies. Enemies sprites are 16x16, so we add 16 to the spacing to avoid overlapping.
const HORIZONTAL_SPACING: int = 11 + 16
## The number of rows of enemies.
const ROWS: int = 5
## The number of columns of enemies.
const COLUMNS: int = 11
## The direction which the formation is moving. 1 means moving to the right, -1 means moving to the left.
var direction: int = 1 

## The horizontal distance the formation will move when moving.
const HORIZONTAL_MOVE_DISTANCE: int = 5
## The vertical distance the formation will move when moving downwards.
const VERTICAL_MOVE_DISTANCE: int = 5

## Enemy scene to spawn.
@onready var packed_enemy: PackedScene = preload("res://entities/enemies/enemy.tscn")
## Wheter any enemy touched the border and the formation still hasnt moved down.
var _has_to_moved_down: bool = false

## Number of total enemies this formation has.
var total_enemies: int
## Number of current alive enemies this formation has.
var alive_enemies: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	_reset_formation(COLUMNS, ROWS)

func _on_move_timer_timeout() -> void:
	for enemy in get_children():
		enemy.move()

	if _has_to_moved_down:
		position.y += VERTICAL_MOVE_DISTANCE
		_has_to_moved_down = false
	else:
		position.x += direction * HORIZONTAL_MOVE_DISTANCE

func formation_position_to_global_position(formation_position: Vector2i) -> Vector2:
	return Vector2(formation_position.x * HORIZONTAL_SPACING, formation_position.y * VERTICAL_SPACING)

func _reset_formation(columns: int, rows: int) -> void:
	for row in range(rows):
		for column in range(columns):
			var enemy: Enemy = packed_enemy.instantiate()
			enemy.formation_position = Vector2i(column, row)
			enemy.position = formation_position_to_global_position(enemy.formation_position)
			add_child(enemy)
			# enemies.append(enemy)

			# One row of angels and 2 of tentacles. The rest are squares.
			if row == 0:
				enemy.set_type(Enemy.Types.ANGEL)
			elif row <= 2:
				enemy.set_type(Enemy.Types.TENTACLE)
			else:
				enemy.set_type(Enemy.Types.SQUARE)
				
			
			enemy.died.connect(_on_enemy_died)
			
	total_enemies = get_child_count()
	alive_enemies = total_enemies

func _on_enemy_died(score: int) -> void:
	alive_enemies -= 1
	enemy_died.emit(score)


## Called when the formation touches the left or right world border. Inverts direction and goes down.
func _on_left_border_area_entered(area: Area2D) -> void:
	print("touched left border")
	direction = 1
	_has_to_moved_down = true

## Called when the formation touches the left or right world border. Inverts direction and goes down.
func _on_right_border_area_entered(area: Area2D) -> void:
	print("touched right border")
	direction =  -1
	_has_to_moved_down = true
