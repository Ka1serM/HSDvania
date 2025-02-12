extends Control

@export var overlay: CanvasLayer
@onready var menu_sound: AudioStreamPlayer = $Overlay/Back/MenuSound
@export var pause_sfx: AudioStreamPlayer
@export var continue_sfx: AudioStreamPlayer

# test kommentar bitte lass mich pushen
func _ready() -> void:
	overlay.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	$Overlay/VBoxContainer/MasterVolume.value = GlobalVariables.master_volume

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		GlobalVariables.paused = !GlobalVariables.paused
		if GlobalVariables.paused:
			pause_sfx.play()
			get_tree().paused = true
		else:
			get_tree().paused = false
			continue_sfx.play()
		self.ToggleVisibility(GlobalVariables.paused)

func _on_master_volume_value_changed(value: float) -> void:
	GlobalVariables.master_volume = value
	menu_sound.play()

func ToggleVisibility(state: bool) -> void:
	visible = state
	overlay.visible = state


func _on_back_pressed() -> void:
	GlobalVariables.paused = false
	ToggleVisibility(false)


func _on_back_mouse_entered() -> void:
	menu_sound.play()
