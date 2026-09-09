extends Bullet

func _on_hit_something(area: Area2D):
	if area is Enemy:
		print("I (the bullet) just hit an enemy")
		_destroy()
	else: 
		print("I (the bullet) hit something else")
