@abstract
class_name Bullet extends Area2D

func _ready():
	var visible_notifier = VisibleOnScreenNotifier2D.new()
	add_child(visible_notifier)
	visible_notifier.screen_exited.connect(queue_free)
