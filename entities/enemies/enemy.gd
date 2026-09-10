class_name Enemy extends Area2D
signal died(score: int)

enum  Types {
	ANGEL, ## Furthest row. 30 points.
	TENTACLE, ## Middle row. 20 points.
	SQUARE, ## Front row, 10 points.
}

## The position inside the formation, starting at (0, 0), a.k.a: (1, 3) - Second column, Fourth row
var formation_position: Vector2i
## Marker representing the position the bullet will spawn
var _bullet_spawn: Marker2D
## Sprites
var _animator: AnimatedSprite2D
## Amount of point that will give when dying.
var _score: int
## Scene to be instantieted as bullet
@export var _bullet_scene: PackedScene = preload("res://entities/enemies/laser.tscn")


func set_type(type: Types):
	##TODO: set correct sprite and point
	match type:
		Types.ANGEL:
			_animator.animation = "angel"
			_score = 30
			$AngelCollisionShape2D.set_deferred("disabled", false)
		
		Types.TENTACLE:
			_animator.animation = "tentacle"
			_score = 20
			$TentacleCollisionShape2D.set_deferred("disabled", false)
		
		Types.SQUARE:
			_animator.animation = "square"
			_score = 10
			$SquareCollisionShape2D.set_deferred("disabled", false)
	
	
	pass

## Spawn a bullet 
func shoot():
	var projectile: Bullet = _bullet_scene.instantiate()
	projectile.global_position = _bullet_spawn.global_position
	
	$"/root/Main/Entities".add_child(projectile)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animator = $AnimatedSprite2D
	_bullet_spawn = $Marker2D

## Moving, just updates frame
func move() -> void:
	## OPS, this makes it move like a snake, but it is not the correct way to do it. The correct way is to move all enemies at once, and then move down when they reach the edge of the screen. Silly me.
	# if formation_position.x == max_column and foward:
	# 	foward = false
	# 	formation_position.y += 1
	# elif formation_position.x == 0 and not foward:
	# 	foward = true
	# 	formation_position.y += 1
	
	# elif foward:
	# 	formation_position.x += 1
	# else:
	# 	formation_position.x -= 1
	

	# Update animation frame	
	if _animator.frame == 0:
		_animator.frame = 1
	else:
		_animator.frame = 0 


## Got shot - body is the bullet
func _on_body_entered(body: Node2D) -> void:
	died.emit(_score)
	queue_free()
	##TODO: on last wave, play frame 2 on death freeze
