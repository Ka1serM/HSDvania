extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("start")
	$Transition.material.set("shader_parameter/progress", 1.0)
	create_tween().tween_property($Transition, "material:shader_parameter/progress", 0.0, 4.0);
	$Timer.start()
	print("hallooo")


# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_timer_timeout() -> void:
	$Transition/Label2.visible = true
