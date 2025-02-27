extends CharacterBody2D

var chaseSpeed = 65
var path_speed = 0.1
var player: Node2D = null
@export var path: Path2D = null
var path_follow_2D: PathFollow2D = null
signal got_stomped
var damage_count = 0 # ab drei hits zerbricht der gegner 
var knockback_strength = 800  # Stärke des Rückstoßes


func _ready():
	# Positioniere die Schriftrolle
	#global_position = Vector2(250, -220) 
	print("Schrifttrolle positioniert bei: ", global_position)
	
	# Finde den Spieler
	player = get_node("../../MainCharacter") as Node2D # /../.. geh zwei schritte nach oben in der Hierarchie
	if player == null:
		print("Spieler wurde nicht gefunden!")

	
	if path != null:
		path_follow_2D = path.get_node("PathFollow2D") as PathFollow2D # Initialisiere path_follow_2D
		if path_follow_2D == null:
			print("PathFollow2D konnte nicht aus 'path' gefunden werden!")
	else:
		print("Pfad ist null, bitte im Inspector zuweisen!")

func _physics_process(delta: float):
	if player != null:
		# Position des Spielers
		var playerPos = player.global_position
		var distanceToPlayer = global_position.distance_to(playerPos)
		
		# Verfolge  Spieler wenn in Reichweite ist
		if distanceToPlayer <= 175:
			print("chasing player")
			var direction = (playerPos - global_position).normalized()
			velocity = direction * chaseSpeed
		else:
			# Lauf den Pfad entlang, falls path_follow_2D existiert
			if path_follow_2D != null:
				path_follow_2D.progress_ratio += delta * path_speed
				var path_target_pos = path_follow_2D.get_global_transform().origin
				var direction_to_path = (path_target_pos - global_position).normalized()
				velocity = direction_to_path * chaseSpeed
			else:
				print("path_follow_2D ist null! Pfadbewegung nicht möglich.")
		
		move_and_slide()  
	else:
		print("Kein Spieler gefunden, keine Bewegung!")
		


func _on_death_area_on_head_body_entered(body: Node2D) -> void:
	print("Kollidierter Node:", body.name)
	if body is CharacterBody2D:  # Prüft ob es ein Charakter ist
		print("Charakter erkannt!")
		got_stomped.emit()
		queue_free() # gegner löschen


func _on_killzone_body_entered(body: Node2D) -> void:
	print("folgender Node erhielt damage: ", body.name)
	Signalhive.emit_signal("player_damaged", 10)
	# Zähler erhöhen
	damage_count += 1
	print("Schaden verursacht:", damage_count, "von 3")
	# Gegner wird zurückgestoßen
	if player != null:
		var knockback_direction = (global_position - player.global_position).normalized()
		velocity = knockback_direction * knockback_strength
		move_and_slide()  

	# Wenn 3 Treffer erreicht sind lösche Gegner
	if damage_count >= 3:
		print("Gegner hat 3-mal Schaden verursacht und wird entfernt.")
		queue_free()
