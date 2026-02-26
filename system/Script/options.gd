extends Node

signal change_back


#func _ready() -> void:
	#$"Control/FullScreen Button".set_toggle_mode(GlobalGameData.fullscreen)

func _on_full_screen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		GlobalGameData.fullscreen = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		GlobalGameData.fullscreen = false


func _on_back_button_pressed() -> void:
	change_back.emit()
