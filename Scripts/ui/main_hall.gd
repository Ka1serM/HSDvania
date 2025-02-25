extends Node


@onready var tile_map_layer: TileMapLayer = $TileMapLayer

var spawnable = preload("res://Scenes/3D/heart_3d.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signalhive.connect("heart_demanded",spawn_heart)
	Signalhive.emit_signal("tilemap_send", tile_map_layer)



func spawn_heart(pos: Vector2):
	var spawned_item: Node2D = spawnable.instantiate()
	spawned_item.position = pos
	add_child(spawned_item)
