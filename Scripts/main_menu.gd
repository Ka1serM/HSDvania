extends Control

@onready var ui_hover_sound = $UI/MarginContainer/VBoxContainer/UiHoverSfx
@onready var gong_sound = $UI/MarginContainer/VBoxContainer/GongSfx
@onready var hsdvania_sfx = $UI/MarginContainer/VBoxContainer/HsdVaniaSfx
@onready var quit_sfx = $UI/MarginContainer/VBoxContainer/QuitSfx
@onready var animation_player = $Scene/SubViewport/AvatarExport/AnimationPlayer
@onready var transition: ColorRect = $UI/Transition

func _ready() -> void:
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))
	animation_player.play("Sitting Idle")

func _on_spielen_pressed() -> void:
	gong_sound.play()
	hsdvania_sfx.play()
	animation_player.play("Sitting Sleep")
	create_tween().tween_property(transition, "material:shader_parameter/progress", 1.0, 4.0);

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Sitting Sleep":
		get_tree().change_scene_to_file("res://Scenes/Levels/main_hall.tscn")

func _on_optionen_pressed() -> void:
	$Settings.ToggleVisibility(true)

func _on_beenden_pressed() -> void:
	quit_sfx.play()
	await get_tree().create_timer(2).timeout
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_animated_sprite_2d_ready() -> void:
	$UI/MarginContainer/Occluder/CharacterSprite.play("default")

func _on_spielen_mouse_entered() -> void:
	ui_hover_sound.play()

func _on_optionen_mouse_entered() -> void:
	ui_hover_sound.play()

func _on_beenden_mouse_entered() -> void:
	ui_hover_sound.play()
