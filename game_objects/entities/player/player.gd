extends CharacterBody2D

var life = 10
var damage = GlobalGameData.damage
var speed = 300.0

#signal change

func _physics_process(delta: float) -> void:

	var direction_x := Input.get_axis("left", "right")
	var direction_y := Input.get_axis("up", "down")
	if direction_x:
		velocity.x = direction_x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	if direction_y:
		velocity.y = direction_y * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()


#func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body.is_in_group("Enemies"):
		#print("aa")
		#emit_signal("change")
