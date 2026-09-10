## This creates and moves a grid formations of enemies. 
## The enemies start on the first 5 rows of the screen, and they move downwards as the game progresses, having in total 10 rows.
## The enemies first go to the edge of the screen, then they move downwards and go to the other edge of the screen, repeating this process until they reach the bottom of the screen (Earth).
class_name Formation extends Node2D
## Emitted whenever an enemy from the formation dies. "score" is the amount of score the dead enemy provides.
signal enemy_died(score: int)
## Emitted whenever the formation has finished spawning in enemies.
signal formation_ready
## Emitted whenever the formation is about to reset.
signal formation_reseting

## Vertical spacing between enemies. Enemies sprites are 16x16, so we add 16 to the spacing to avoid overlapping.
const VERTICAL_SPACING: int = 15 + 16
## Horizontal spacing between enemies. Enemies sprites are 16x16, so we add 16 to the spacing to avoid overlapping.
const HORIZONTAL_SPACING: int = 11 + 16
## The number of rows of enemies.
const ROWS: int = 5
## The number of columns of enemies.
const COLUMNS: int = 14
## The amount of time between each enemy spawn when resetting formation.
const FORMATION_SPAWN_DELAY_AMOUNT: float = 0.025
## The horizontal distance the formation will move when moving.
const HORIZONTAL_MOVE_DISTANCE: int = 2
## The vertical distance the formation will move when moving downwards.
const VERTICAL_MOVE_DISTANCE: int = 5


## Enemy scene to spawn.
@onready var packed_enemy: PackedScene = preload("res://entities/enemies/enemy.tscn")
## Number of total enemies this formation has.
var total_enemies: int
## Number of current alive enemies this formation has.
var alive_enemies: int

## Wheter any enemy touched the border and the formation still hasnt moved down.
var _has_to_moved_down: bool = false
## The direction which the formation is moving. 1 means moving to the right, -1 means moving to the left.
var _direction: int = 1 
## The initial position of the formation when it is created. Used to reset the formation to its original position.
var _initial_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	await get_tree().create_timer(0.1).timeout
	_initial_position = position

	_reset_formation(COLUMNS, ROWS)

func _on_move_timer_timeout() -> void:
	for enemy in get_children():
		enemy.move()

	if _has_to_moved_down:
		position.y += VERTICAL_MOVE_DISTANCE
		_has_to_moved_down = false
	else:
		position.x += _direction * HORIZONTAL_MOVE_DISTANCE

func formation_position_to_global_position(formation_position: Vector2i) -> Vector2:
	return Vector2(formation_position.x * HORIZONTAL_SPACING, formation_position.y * VERTICAL_SPACING)

## Resets the formation to its initial state, spawning enemies in a grid pattern in the process. 
## Emits `formation_reseting` signal when the formation is about to reset, and `formation_ready` signal when the formation has finished spawning in enemies.
func _reset_formation(columns: int, rows: int) -> void:
	formation_reseting.emit()

	position = _initial_position
	for row in range(rows):
		for column in range(columns):
			var enemy: Enemy = packed_enemy.instantiate()
			enemy.formation_position = Vector2i(column, row)
			enemy.position = formation_position_to_global_position(enemy.formation_position)
			add_child(enemy)
			# enemies.append(enemy)
			await get_tree().create_timer(FORMATION_SPAWN_DELAY_AMOUNT).timeout

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
	
	formation_ready.emit()

func _on_enemy_died(score: int) -> void:
	alive_enemies -= 1
	enemy_died.emit(score)


## Called when the formation touches the left or right world border. Inverts _direction and goes down.
func _on_left_border_area_entered(area: Area2D) -> void:
	print("touched left border")
	_direction = 1
	_has_to_moved_down = true

## Called when the formation touches the left or right world border. Inverts _direction and goes down.
func _on_right_border_area_entered(area: Area2D) -> void:
	print("touched right border")
	_direction =  -1
	_has_to_moved_down = true
