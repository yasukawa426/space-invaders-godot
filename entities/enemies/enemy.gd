class_name Enemy extends Area2D
signal died(score: int)

enum  Types {
	ANGEL, ## Furthest row. 30 points.
	DUDE,
	SNAKE,
}


## Marker representing the position the bullet will spawn
var bullet_spawn: Marker2D
## Sprites
var _animator: AnimatedSprite2D
## Amount of point that will give when dying.
var _score: int

## Bullet that will be spawned when shooting
@export var bullet: PackedScene

func set_type(type: Types):
	##TODO: set correct sprite and point
	match type:
		Types.ANGEL:
			_animator.animation = "angel"
			_score = 30
			
	
	
	pass

func shoot():
	# TODO: shoot and stuff
	var projectile: Bullet = bullet.instantiate()
	Bullet.global_position = bullet_spawn.global_position
	
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animator = $AnimatedSprite2D
	bullet_spawn = $Marker2D

## Moving, just updates frame
func move() -> void:
	if _animator.frame == 0:
		_animator.frame = 1
	else:
		_animator.frame = 0 


## Got shot
func _on_body_entered(body: Node2D) -> void:
	died.emit(_score)
	queue_free()
