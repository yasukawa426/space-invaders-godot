## This creates and moves a grid formations of enemies. 
## The enemies start on the first 5 rows of the screen, and they move downwards as the game progresses, having in total 10 rows.
## The enemies first go to the edge of the screen, then they move downwards and go to the other edge of the screen, repeating this process until they reach the bottom of the screen (Earth).
class_name Formation extends Node2D
## Emitted whenever an enemy from the formation dies. "score" is the amount of score the dead enemy provides. "alive_enemies" is the amount of enemies still alive in the formation.
signal enemy_died(score: int, alive_enemies: int)
## Emitted whenever the formation has finished spawning in enemies. "total_enemies" is the total amount of created enemies in the formation.
signal formation_ready (total_enemies: int)
## Emitted whenever the formation is about to reset.
signal formation_reseting
## Emitted whenever the formation has been destroyed (all enemies are dead).
signal formation_destroyed

## Vertical spacing between enemies. Enemies sprites are 16x16, so we add 16 to the spacing to avoid overlapping.
const VERTICAL_SPACING: int = 15 + 16
## Horizontal spacing between enemies. Enemies sprites are 16x16, so we add 16 to the spacing to avoid overlapping.
const HORIZONTAL_SPACING: int = 11 + 16
## The number of rows of enemies.
const ROWS: int = 5
## The number of columns of enemies.
const COLUMNS: int = 14
## The total amount of time the formation should take to spawn in seconds.
const FORMATION_TOTAL_SPAWN_DELAY_AMOUNT: float = 1.25
## The horizontal distance the formation will move when moving.
const HORIZONTAL_MOVE_DISTANCE: int = 2
## The vertical distance the formation will move when moving downwards.
const VERTICAL_MOVE_DISTANCE: int = 5
## Enemy scene to spawn.
const _PACKED_ENEMY: PackedScene = preload("res://entities/enemies/enemy.tscn")
## The initial pitch scale of the formation movement sound. It will have 4 levels, and each time the sound is played, the pitch scale will decrease by _AUDIO_PITCH_SCALE_STEP. When it reaches the last level, it will reset to this value.
const _INITIAL_AUDIO_PITCH_SCALE: float = 0.6
## The amount the pitch scale of the formation movement sound will decrease each time the sound is played.
const _AUDIO_PITCH_SCALE_STEP: float = 0.1
## The initial amount of time in seconds it takes for an enemy to charge before shooting a bullet. 
const _INITIAL_ENEMY_CHARGE_TIME: float = 2.0
## The initial amount of time in seconds between each different individual enemy starts charging. Slightly randomized to avoid enemies having a set rhythm.
const _INITIAL_ENEMY_CHARGE_DELAY: float = 4.0

## AudioStreamPlayer for the formation movement.
@onready var move_audio_player: AudioStreamPlayer = $"../FormationAudioStreamPlayer"
## Timer for controlling the time between each different individual enemy starts charging.
@onready var _shoot_timer: Timer = $"../ShootTimer"
## The amount of time it takes for an enemy to charge before shooting a bullet. Decreases as enemies die.
@onready var _enemy_charge_time: float = _INITIAL_ENEMY_CHARGE_TIME
## The amount of time between each different individual enemy starts charging. Decreases as enemies die.
@onready var _enemy_charge_delay: float = _INITIAL_ENEMY_CHARGE_DELAY
## Scene to be instantieted as enemies bullet
@export var _bullet_scene: PackedScene = preload("res://entities/enemies/laser.tscn")

## Number of total enemies this formation has.
var _total_enemies: int
## Number of current alive enemies this formation has.
var _alive_enemies: int
## Wheter any enemy touched the border and the formation still hasnt moved down.
var _has_to_move_down: bool = false
## The direction which the formation is moving. 1 means moving to the right, -1 means moving to the left.
var _direction: int = 1 
## The initial position of the formation when it is created. Used to reset the formation to its original position.
var _initial_position: Vector2

# TODO: decrease shooting delay and shooting charging time to increase dificculty based on wave 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	await get_tree().create_timer(0.1).timeout
	_initial_position = position

	_reset_formation(COLUMNS, ROWS)

	move_audio_player.set_pitch_scale(_INITIAL_AUDIO_PITCH_SCALE)
	

## Callend when the move timer times out. Tell every enemy in the formation to update sprite, moves the entire formation, and play a sound.
func _on_move_timer_timeout() -> void:
	for enemy in get_children():
		enemy.move()

	if _has_to_move_down:
		position.y += VERTICAL_MOVE_DISTANCE
		_has_to_move_down = false
	else:
		position.x += _direction * HORIZONTAL_MOVE_DISTANCE


## Called when the sound timer times out. Plays the movement sound and decreases the pitch scale of the sound. The pitch scale has 4 levels, and when it reaches the last one, it resets to the initial pitch scale. 
func _on_sound_timer_timeout() -> void:
	
	var min_pitch_scale: float = _INITIAL_AUDIO_PITCH_SCALE - _AUDIO_PITCH_SCALE_STEP * 3

	# float numbers are fuck,ing wierd so i am doing these rounding when comparing them. 
	if snappedf(move_audio_player.pitch_scale, _AUDIO_PITCH_SCALE_STEP) <= snappedf(min_pitch_scale, _AUDIO_PITCH_SCALE_STEP):
		move_audio_player.set_pitch_scale(_INITIAL_AUDIO_PITCH_SCALE)
	else:
		move_audio_player.set_pitch_scale(move_audio_player.pitch_scale - _AUDIO_PITCH_SCALE_STEP)

	print("Formation audio pitch scale is ",  move_audio_player.pitch_scale)
	move_audio_player.play()

func _on_enemy_died(score: int) -> void:
	_alive_enemies -= 1
	enemy_died.emit(score, _alive_enemies)

	## all dead
	if _alive_enemies <= 0:
		formation_destroyed.emit()

## Called when an enemy has finished charging and should shoot a bullet. Spawns a bullet as a sibling of the formation.
func _on_enemy_finished_charging(bullet_global_spawn_position: Vector2) -> void:
	var projectile: Bullet = _bullet_scene.instantiate()
	projectile.global_position = bullet_global_spawn_position
	
	add_sibling(projectile)

## Called when the shoot timer times out. Tells a random enemy that has no other enemy below it to start charging to shoot a bullet, and then restart the timer with a new delay.
func _on_shoot_timer_timeout() -> void:
	var enemies: Array[Enemy] = []

	for enemy in get_children():
		if enemy is Enemy:
			enemies.append(enemy)
	
	## list of enemies that are allowed to shoot.
	var shooters: Array[Enemy] = []


	for enemy in enemies:
		var can_shoot: bool = true

		for other_enemy in enemies:
			# if there is a enemy directly bellow of it, its not allowed to shoot. go to the next one
			if other_enemy.formation_position.y > enemy.formation_position.y and enemy.formation_position.x == other_enemy.formation_position.x:
				can_shoot = false
				break
		
		# if not, assign as a shooter
		if can_shoot:
			shooters.append(enemy)

	# no one can shoot babe
	if shooters.is_empty():
		return

	# picks a random shooter and tells them to start charging.
	var random_enemy: Enemy = shooters.pick_random()
	random_enemy.start_charging(_enemy_charge_time)

	# starts the shoot timer again with a +-20% variation
	_shoot_timer.start(_enemy_charge_delay * randf_range(0.8, 1.2))

## Called when the formation touches the left world border. Sets the direction to the right and _has_to_move_down to true.
func _on_left_border_area_entered(_area: Area2D) -> void:
	print("touched left border")
	_direction = 1
	_has_to_move_down = true

## Called when the formation touches the right world border. Sets the direction to the left and _has_to_move_down to true.
func _on_right_border_area_entered(_area: Area2D) -> void:
	print("touched right border")
	_direction =  -1
	_has_to_move_down = true


func formation_position_to_global_position(formation_position: Vector2i) -> Vector2:
	return Vector2(formation_position.x * HORIZONTAL_SPACING, formation_position.y * VERTICAL_SPACING)

## Resets the formation to its initial state, spawning enemies in a grid pattern in the process. 
## Emits `formation_reseting` signal when the formation is about to reset, and `formation_ready` signal when the formation has finished spawning in enemies.
func _reset_formation(columns: int, rows: int) -> void:
	formation_reseting.emit()

	_direction = 1
	_has_to_move_down = false
	position = _initial_position

	_total_enemies = columns * rows
	_alive_enemies = _total_enemies

	var enemy_spawn_delay: float = FORMATION_TOTAL_SPAWN_DELAY_AMOUNT / float(_total_enemies)

	for enemy in get_children():
		enemy.queue_free()

	for row in range(rows):
		for column in range(columns):
			var enemy: Enemy = _PACKED_ENEMY.instantiate()

			enemy.formation_position = Vector2i(column, row)
			enemy.position = formation_position_to_global_position(enemy.formation_position)
			add_child(enemy)

			# One row of angels and 2 of tentacles. The rest are squares.
			if row == 0:
				enemy.set_type(Enemy.Types.ANGEL)
			elif row <= 2:
				enemy.set_type(Enemy.Types.TENTACLE)
			else:
				enemy.set_type(Enemy.Types.SQUARE)
				
			enemy.died.connect(_on_enemy_died)
			enemy.finished_charging.connect(_on_enemy_finished_charging)

			await get_tree().create_timer(enemy_spawn_delay).timeout
	
	_shoot_timer.start(_enemy_charge_delay)
	formation_ready.emit(_total_enemies)
