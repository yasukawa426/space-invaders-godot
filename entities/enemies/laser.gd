extends Bullet

## Hits anything, gets deleted. 
func _on_hit_something(area: Area2D):
	_destroy()
