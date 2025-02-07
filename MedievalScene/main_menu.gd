extends Control

@onready var video_player = $VideoStreamPlayer
@onready var start_button = $VBoxContainer/StartButton
@onready var exit_button = $VBoxContainer/ExitButton

var is_muted = false

func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://MedievalScene/MedievalScene.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
