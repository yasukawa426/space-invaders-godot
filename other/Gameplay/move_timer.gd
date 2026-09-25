## This script controls the time between each movement of the enemy formation. The wait time decreases as enemies die. It also pauses the movement for a brief moment when an enemy dies. The move timer node has a sound timer as a child node, which is used to play the movement sound. Both of these have their wait times synchronized with each other, but the sound timer does not pause to maintain the sound rhytim.
extends Timer

const MIN_WAIT_TIME: float = 0.01
const MIN_SOUND_WAIT_TIME: float = 0.05
const MAX_WAIT_TIME: float = 0.7
const DEATH_PAUSE_AMOUNT: float = 0.2

@onready var sound_timer: Timer = $SoundTimer
## Number of total enemies the formation has. Updated on _on_grid_formation_formation_ready.
var _total_enemies: int = 0

## Decreases await time when enemy dies and stops movement for a moment.
func _on_grid_formation_enemy_died(_score: int, alive_enemies: int) -> void:
	var progress: float = float(alive_enemies) / float(_total_enemies)
	
	paused = true
	await get_tree().create_timer(DEATH_PAUSE_AMOUNT).timeout
	paused = false
	# Gets exponentially faster the less enemy there is
	var new_wait_time = lerp(MIN_WAIT_TIME, MAX_WAIT_TIME, progress ** 1.2)
	
	print("alive: ", alive_enemies, "total: ", _total_enemies, "progress: ",  progress ** 2)
	set_wait_timers(new_wait_time)
	print(new_wait_time)

## Timer start when the formation is ready.
func _on_grid_formation_formation_ready(total_enemies: int) -> void:
	_total_enemies = total_enemies
	start_timers()

## Resets the timer to the maximum wait time and stops it. Called when the formation is reset.
func reset_timer() -> void:
	set_wait_timers(MAX_WAIT_TIME)
	stop_timers()
	
## Sets the wait time for both the move and the sound timer. Should be called whenever the wait time needs to be changed as they need to be synchronized.
func set_wait_timers(amount: float) -> void:
	wait_time = amount

	if amount < MIN_SOUND_WAIT_TIME:
		sound_timer.wait_time = MIN_SOUND_WAIT_TIME
	else:
		sound_timer.wait_time = amount

func start_timers(amount: float = 0) -> void:
	start(amount)
	sound_timer.start(amount)

func stop_timers() -> void:
	stop()
	sound_timer.stop()

## Called when the formation is about to reset. Resets the timer to the maximum wait time and stops it.
func _on_grid_formation_formation_reseting() -> void:
	reset_timer()

## Called when the formation has been destroyed (all enemies are dead). Resets the timer to the maximum wait time and stops it.
func _on_grid_formation_formation_destroyed() -> void:
	reset_timer()
