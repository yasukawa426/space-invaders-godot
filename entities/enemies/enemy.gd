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
## Scene to be instantieted as bullet
@export var _bullet_scene: PackedScene = preload("res://entities/enemies/laser.tscn")


func set_type(type: Types):
	##TODO: set correct sprite and point
	match type:
		Types.ANGEL:
			_animator.animation = "angel"
			_score = 30
			
	
	
	pass

## Spawn a bullet 
func shoot():
	var projectile: Bullet = _bullet_scene.instantiate()
	projectile.global_position = bullet_spawn.global_position
	
	get_tree().root.add_child(projectile)


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


## Got shot - body is the bullet
func _on_body_entered(body: Node2D) -> void:
	died.emit(_score)
	queue_free()
