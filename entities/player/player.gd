class_name Player extends CharacterBody2D

## The maximum speed the player can move at.
const MAX_SPEED: float = 150.0
## The acceleration of the player when moving.
const ACCELERATION: float = 20000

## Amount of degrees the player will rotate when moving left or right.
const _TURN_DEGREE: float = 10.0

@onready var _screen_size: Vector2 = get_viewport_rect().size
@onready var _sprite_width: int = $Sprite2D.texture.get_width()
## Bullet that will be spawned when shooting. Should be a scene that extends Bullet.
@export var bullet: PackedScene = load("res://entities/player/missile.tscn");

## Direction the player is currently moving towards. -1 for left, 1 for right, 0 for no movement.
var _direction: float = 0.0

## Wether the player can shoot. Will only be true if there is no existing missile. 
var _can_fire: bool = true



func _physics_process(delta: float) -> void:
	if _direction:
		velocity.x = move_toward(velocity.x, MAX_SPEED * _direction, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION  * delta * 2)

	move_and_slide()

	var tween: Tween = create_tween()
	tween.tween_property($Sprite2D, "rotation", deg_to_rad(_direction * _TURN_DEGREE), 0.05)

	## Clamp the player's position to the screen bounds considering the sprite's width.
	position = position.clamp(Vector2(0 + (_sprite_width / 2.0), position.y), Vector2(_screen_size.x - (_sprite_width / 2.0), position.y))

func _unhandled_input(event: InputEvent) -> void:
	_direction = Input.get_axis("move_left", "move_right")

	if event.is_action_pressed("shoot") and _can_fire:
		_shoot()

func _shoot():
	var missile: Bullet = bullet.instantiate()
	
	missile.global_position = $BulletMarker2D.global_position
	missile.destroyed.connect(_on_missile_destroyed)
	
	add_sibling(missile)
	_can_fire = false

func _on_missile_destroyed():
	_can_fire = true
