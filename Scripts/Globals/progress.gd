extends Node

var already_collected_list: Array[Vector2i] = []
var tilemap:TileMapLayer
var bafoegCord:Vector2 = Vector2(1,4)


var doubleJumpCollected = false:
	set(val):
		if !doubleJumpCollected:
			doubleJumpCollected = val

var HTTPMessageCollected = false


func _ready() -> void:
	Signalhive.connect("tilemap_send", set_tilemap)
	Signalhive.connect("collected_bafoeg",add_to_collected_list)
	Signalhive.connect("collected_double_jump", add_to_collected_list)
	Signalhive.connect("retry", reset_bafoeg_tiles)
	Signalhive.connect("collected_HTTP_message",add_to_collected_list)




func add_to_collected_list(tile_cord:Vector2i, type: int) -> void:

	match type:
		1:
			GlobalVariables.bafoeg_count += 1
			if(!GlobalVariables.collectedFirstBafoeg):
				GlobalVariables.collectedFirstBafoeg = true
				Signalhive.emit_signal("queued_message", "What is this? A piece of my Bafoeg Application?")
				Signalhive.emit_signal("queued_message", "Oh no... Of course I forgot to finish my Bafoeg Application.")
				Signalhive.emit_signal("queued_message", "I should collect all of these, and finish them as soon as I can!")
			elif(GlobalVariables.bafoeg_count == 8):
				get_tree().change_scene_to_file("res://Scenes/Levels/awsome_creditsroom.tscn")
			else:
				Signalhive.emit_signal("queued_message", "Found another one!")
			already_collected_list.append(tile_cord)
		2:
			doubleJumpCollected = true
			
		3:
			if !HTTPMessageCollected:
				HTTPMessageCollected = true
				Signalhive.emit_signal("queued_message", "It is a HTTP client!")
				Signalhive.emit_signal("queued_message", "With this I should be able to send HTTP messages with Z.")
				Signalhive.emit_signal("queued_message", "It is not the safe version of the protocoll, so I better watch my step...")
	print(already_collected_list)
	
	
func reset_bafoeg_tiles() -> void:
	for i in already_collected_list.size():
		var cords_to_be_placed:Vector2i = already_collected_list[i]
		tilemap.set_cell(cords_to_be_placed,0,bafoegCord,0)
		
	already_collected_list.clear()

func set_tilemap(incoming_tilemap) -> void:
	if tilemap == null:
		tilemap = incoming_tilemap
