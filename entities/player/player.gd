extends CharacterBody2D
const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@onready var _screen_size: Vector2 = get_viewport_rect().size
@onready var _sprite_width: int = $Sprite2D.texture.get_width()
## Bullet that will be spawned when shooting. Should be a scene that extends Bullet.
@export var bullet: PackedScene;

## Wether the player can shoot. Will only be true if there is no existing missile. 
var _can_fire: bool = true

func _process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	position = position.clamp(Vector2(0 + (_sprite_width / 2), position.y), Vector2(_screen_size.x - (_sprite_width / 2), position.y))

func _unhandled_input(event: InputEvent) -> void:
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
