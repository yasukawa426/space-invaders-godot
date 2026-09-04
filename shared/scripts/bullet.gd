## All bullets move straight at a given direction and are destroyed when leaving the screen. emitting the destroyed signal.
@abstract
class_name Bullet extends Area2D
signal destroyed
## Bullet move speed, should be set when creating the bullet. Defaults as 100.
@export var speed: float = 100
## Bullet flying direction. Should be only Vector2.UP or DOWN. Defaults as down.
@export var flying_direction: Direction = Direction.DOWN

enum Direction {
	## Goes UP
	UP, 
	## Goes DOWN
	DOWN,
	## Doesn't move
	NONE,
}

func _ready():
	var visible_notifier = VisibleOnScreenNotifier2D.new()
	add_child(visible_notifier)
	visible_notifier.screen_exited.connect(_destroy)
	
	# FIXME: not detecting when hitting enemy
	area_entered.connect(_destroy)


func _process(delta: float) -> void:
	var velocity: Vector2 = _get_direction_vector(flying_direction)
	
	velocity = velocity * speed
	position += velocity * delta


func _get_direction_vector(direction: Direction) -> Vector2:
	match direction:
		Direction.UP:
			return Vector2.UP
		Direction.DOWN:
			return Vector2.DOWN
		Direction.NONE:
			return Vector2.ZERO
		
	return Vector2.DOWN

func _destroy() -> void:
	destroyed.emit()
	queue_free()
