extends Timer

const MIN_WAIT_TIME: float = 0.01
const MAX_WAIT_TIME: float = 0.7

func _ready() -> void:
	start(MAX_WAIT_TIME)

## Decreases await time when enemy dies.
func _on_grid_formation_enemy_died(score: int) -> void:
	var alive: int =  $"../Entities/GridFormation".alive_enemies 
	var total: int =  $"../Entities/GridFormation".total_enemies
	
	var progress: float = float(alive) / float(total)
	# Gets exponentially faster the less enemy there is
	var new_wait_time = lerp(MIN_WAIT_TIME, MAX_WAIT_TIME, progress ** 1.2)
	
	print("alive: ", alive, "total: ", total, "progress: ",  progress)
	wait_time = new_wait_time
	print(new_wait_time)
