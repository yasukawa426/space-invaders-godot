extends Timer

const MIN_WAIT_TIME: float = 0.01
const MAX_WAIT_TIME: float = 0.7
const DEATH_PAUSE_AMOUNT: float = 0.2

## Decreases await time when enemy dies and stops movement for a moment.
func _on_grid_formation_enemy_died(score: int) -> void:
	var alive: int =  $"../Entities/GridFormation".alive_enemies 
	var total: int =  $"../Entities/GridFormation".total_enemies
	var progress: float = float(alive) / float(total)
	
	paused = true
	await get_tree().create_timer(DEATH_PAUSE_AMOUNT).timeout
	paused = false
	# Gets exponentially faster the less enemy there is
	var new_wait_time = lerp(MIN_WAIT_TIME, MAX_WAIT_TIME, progress ** 1.2)
	
	print("alive: ", alive, "total: ", total, "progress: ",  progress ** 2)
	wait_time = new_wait_time
	print(new_wait_time)

## Timer start when the formation is ready.
func _on_grid_formation_formation_ready() -> void:
	start(MAX_WAIT_TIME)

## Resets the timer to the maximum wait time and stops it. Called when the formation is reset.
func reset_timer() -> void:
	wait_time = MAX_WAIT_TIME
	stop()

## Called when the formation is about to reset. Resets the timer to the maximum wait time and stops it.
func _on_grid_formation_formation_reseting() -> void:
	reset_timer()
