extends Node2D

@export var parallax_intensity: float = 0.0045
@onready var camera_3d: Camera3D = $SubViewport/Camera3D

var current_position: Vector3

func _ready() -> void:
	current_position = camera_3d.global_position
	
	Signalhive.connect("camera_3d_update", _on_camera_3d_update)

func _on_camera_3d_update(update: Vector2) -> void:
	camera_3d.global_position = current_position - Vector3(update.x, 0, update.y) * parallax_intensity
