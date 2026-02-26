extends CharacterBody2D

@export var life = 10
@export var max_life = 10
@export var speed = 300.0


func _ready() -> void:
	GlobalGameData.player_life = life
	GlobalGameData.player_max_life = max_life

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
