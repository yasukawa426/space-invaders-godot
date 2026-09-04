extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@onready var _screen_size: Vector2 = get_viewport_rect().size
@onready var _sprite_width: int = $Sprite2D.texture.get_width()


func _process(delta: float) -> void:
	
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	position = position.clamp(Vector2(0 + (_sprite_width / 2), position.y), Vector2(_screen_size.x - (_sprite_width / 2), position.y))
