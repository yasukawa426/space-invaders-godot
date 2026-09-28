class_name Enemy extends Area2D
## Emitted whenever the enemy dies. "score" is the amount of score the dead enemy provides.
signal died(score: int)
## Emitted whenever the finished charging and should shoot a bullet. The formation should spawn a bullet as a sibling when this happens. "bullet_spawn_position" is the global position of the bullet spawn marker.
signal finished_charging(bullet_global_spawn_position: Vector2)

enum  Types {
	ANGEL, ## Furthest row. 30 points.
	TENTACLE, ## Middle row. 20 points.
	SQUARE, ## Front row, 10 points.
}

const ORIGINAL_HALO_COLOR: Color = Color(255, 255, 255, 255)
const CHARGED_HALO_COLOR: Color = Color(0.451, 0.318, 0.302, 1.0)
#const CHARGED_HALO_COLOR: Color = Color(0.506, 0.812, 0.855, 0.996)

## The position inside the formation, starting at (0, 0), a.k.a: (1, 3) - Second column, Fourth row
var formation_position: Vector2i
## Marker representing the position the bullet will spawn
var _bullet_spawn: Marker2D
## Sprites
var _animator: AnimatedSprite2D
## Amount of point that will give when dying.
var _score: int

## GPUParticles2D used to emit charging particles.
@onready var _halo_particles: GPUParticles2D = $HaloSprite2D/HaloGPUParticles2D

## Time the alien takes to materialize in seconds when spawned.
@export var materialize_duration: float = 0.8

func set_type(type: Types):
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

		_:
			assert(false, "Invalid enemy type: " + str(type))
		
	# materializes in
	var tween: Tween = create_tween()
	tween.tween_method(_change_shader_progress, 1.0, 0.0, materialize_duration)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animator = $AnimatedSprite2D
	_bullet_spawn = $Marker2D

## Starts charging to fire a bullet for `time` seconds. When the charge is finished, it will emit the `shoot_bullet` signal.
## Enemy's halo will change color and emit particles while charging.
func start_charging(time: float) -> void:
	$ChargeTimer.start(time)
	_halo_particles.emitting = true
	
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate", CHARGED_HALO_COLOR, time)
	
	await tween.finished
	_halo_particles.emitting = false
	
	tween = create_tween()
	tween.tween_property(self, "modulate", ORIGINAL_HALO_COLOR, time / 3.0)

## Moving, just updates frame
func move() -> void:
	# Update animation frame	
	if _animator.frame == 0:
		_animator.frame = 1
	else:
		_animator.frame = 0 


## Got shot - body is the bullet
func _on_body_entered(body: Node2D) -> void:
	died.emit(_score)
	queue_free()


func _on_charge_timer_timeout() -> void:
	finished_charging.emit(_bullet_spawn.global_position)

func _change_shader_progress(value: float) -> void:
	material.set_shader_parameter("progress", value)
