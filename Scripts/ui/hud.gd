extends  Control

@onready var heart_bar = $HeartBar
@onready var health_bar = $HealthBar

@onready var gameover_sfx = $GameOver/GameoverSfx
@onready var continue_sfx = $ContinueSfx

@onready var bafoeg_text: Label = $BafoegText

@onready var game_over: Label = $GameOver
@onready var transition: ColorRect = $Transition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Transition.material.set("shader_parameter/progress", 1.0)  # Set initial value
	Signalhive.connect("player_died", game_over_screen)
	Signalhive.connect("retry", normal_HUD)
	Signalhive.connect("collected_bafoeg", update_bafoeg_text)
	
	#Wait for the scene to finish loading
	await get_tree().create_timer(0.5).timeout
	create_tween().tween_property($Transition, "material:shader_parameter/progress", 0.0, 4.0);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_health(health):
	health_bar.update(health)
	
func game_over_screen() -> void:
	game_over.self_modulate = Color(1, 1, 1, 0)
	game_over.visible = true
	
	health_bar.visible = false
	bafoeg_text.visible = false
	gameover_sfx.play()
	var tween = create_tween()
	tween.tween_property(transition, "material:shader_parameter/progress", 1.0, 1.0)
	await tween.finished
	create_tween().tween_property(game_over, "self_modulate", Color(1, 1, 1, 1), 4.0)

func normal_HUD() -> void:
	game_over.visible = false
	game_over.self_modulate = Color(1, 1, 1, 1)
	
	health_bar.visible = true
	bafoeg_text.visible = true
	bafoeg_text.text = "Bafög: 0/8"
	GlobalVariables.bafoeg_count = 0
	continue_sfx.play()
	create_tween().tween_property(transition, "material:shader_parameter/progress", 0.0, 1.0)
	create_tween().tween_property(game_over, "self_modulate", Color(1, 1, 1, 0), 1.0)


func update_bafoeg_text(_pos,_type) -> void:
	if !bafoeg_text.visible:
		bafoeg_text.visible = !bafoeg_text.visible
	bafoeg_text.text = str("Bafög: " ,GlobalVariables.bafoeg_count ,"/8")
	if GlobalVariables.bafoeg_count == 8:
		$WinSFX.play()
		var tween = create_tween()
		tween.tween_property($Transition, "material:shader_parameter/progress", 1.0, 3.0);
		await tween.finished
		get_tree().change_scene_to_file("res://Scenes/Levels/awsome_creditsroom.tscn")


func _on_text_fade_in_timer_timeout() -> void:
	create_tween().tween_property($GameOver, "self_modulate", Color(1, 1, 1, 1), 4.0);
