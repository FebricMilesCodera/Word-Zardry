extends Control

@onready var playerName = $ButtonsSide/playerName
@onready var playButton = $ButtonsSide/playButton
@onready var optionsButton = $ButtonsSide/optionsButton
@onready var quitButton = $ButtonsSide/quitButton
@onready var logoutButton = $ButtonsSide/logoutButton

# New variables for the quit prompt
@onready var quitPrompt = $quitPrompt
@onready var promptLabel = $quitPrompt/simpleBox/promptLabel
@onready var yesButton = $quitPrompt/simpleBox/yesButton
@onready var noButton = $quitPrompt/simpleBox/noButton

func _ready():
	playerName = $ButtonsSide/playerName
	playerName.text = Global.username
	quitPrompt.visible = false
	
	Global.play_background_music()
	
	# Connect signals for the quit prompt buttons
	yesButton.connect("pressed", Callable(self, "_on_yes_button_pressed"))
	noButton.connect("pressed", Callable(self, "_on_no_button_pressed"))

	playButton.connect("mouse_entered", Callable(self, "_on_button_hovered"))
	optionsButton.connect("mouse_entered", Callable(self, "_on_button_hovered"))
	quitButton.connect("mouse_entered", Callable(self, "_on_button_hovered"))
	logoutButton.connect("mouse_entered", Callable(self, "_on_button_hovered"))
	yesButton.connect("mouse_entered", Callable(self, "_on_button_hovered"))
	noButton.connect("mouse_entered", Callable(self, "_on_button_hovered"))

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://quest_options.tscn")
	Global.button_click_sfx()

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://options.tscn")
	Global.button_click_sfx()

func _on_quit_button_pressed():
	quitPrompt.visible = true
	Global.button_click_sfx()

func _on_profile_button_pressed():
	get_tree().change_scene_to_file("res://profile.tscn")
	Global.button_click_sfx()

func _on_logout_button_pressed():
	Global.username = ""
	get_tree().change_scene_to_file("res://login.tscn")
	Global.button_click_sfx()

# Handler for when "Yes" is clicked in the quit prompt
func _on_yes_button_pressed():
	get_tree().quit()
	Global.button_click_sfx()

# Handler for when "No" is clicked in the quit prompt
func _on_no_button_pressed():
	quitPrompt.visible = false
	Global.button_click_sfx()
	
func _on_button_hovered():
	Global.button_hover_sfx()
