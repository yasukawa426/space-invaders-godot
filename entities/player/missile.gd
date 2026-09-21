extends Bullet

func _on_hit_something(area: Area2D):
	if area is Enemy:
		print("I (the bullet) just hit an enemy")
		_destroy()
	elif area is Bullet:
		print("I (the bullet) just hit a bullet")
	else: 
		print("I (the bullet) hit something else")
