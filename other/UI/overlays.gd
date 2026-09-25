extends Control
## The alpha value of each visor crack (how transparent they are). Must be between 0 (invisible) and 1 (opaque).
@export var cracks_alpha: float = 0.6
## Time in seconds that each visor cracks takes to appear.
@export var cracks_transition_time: float = 0.01

func _hit_flash() -> void:
	var node: ColorRect = $HitFlash
	var tween: Tween = create_tween()
	tween.tween_property(node, "modulate:a", 1, 0.05)
	tween.tween_property(node, "modulate:a", 0.0, 0.05)

func _update_cracks(hp: int) -> void:
	var tween: Tween = create_tween()
	var node: TextureRect

	node = $ScreenCrack1
	if hp <= 3:
		tween.tween_property(node, "modulate:a", cracks_alpha, cracks_transition_time)
	else:
		tween.tween_property(node, "modulate:a", 0.0, cracks_transition_time)
		
	node = $ScreenCrack2
	if hp <= 2:
		tween.tween_property(node, "modulate:a", cracks_alpha, cracks_transition_time)
	else:
		tween.tween_property(node, "modulate:a", 0.0, cracks_transition_time)
		
	node = $ScreenCrack3
	if hp <= 1:
		tween.tween_property(node, "modulate:a", cracks_alpha, cracks_transition_time)
	else:
		tween.tween_property(node, "modulate:a", 0.0, cracks_transition_time)
	

func player_damaged(hp: int) -> void:
	_hit_flash()
	_update_cracks(hp)

func player_healed(hp: int) -> void:
	_update_cracks(hp)
