extends Control

@onready var bgmusicSlider = $CenterContainer/simpleBox/bgmusicSlider
@onready var sfxSlider = $CenterContainer/simpleBox/sfxSlider
@onready var bgmusicButton = $CenterContainer/simpleBox/bgmusicButton
@onready var sfxButton = $CenterContainer/simpleBox/sfxButton
@onready var fullscreenButton = $CenterContainer/simpleBox/fullscreenButton
@onready var confirmButton = $CenterContainer/simpleBox/confirmButton
@onready var backButton = $backButton

func _ready():
	# Connect signals
	bgmusicSlider.connect("value_changed", Callable(self, "_on_bgmusicSlider_value_changed"))
	sfxSlider.connect("value_changed", Callable(self, "_on_sfxSlider_value_changed"))
	bgmusicButton.connect("toggled", Callable(self, "_on_bgmusicButton_toggled"))
	sfxButton.connect("toggled", Callable(self, "_on_sfxButton_toggled"))
	fullscreenButton.connect("toggled", Callable(self, "_on_fullscreenButton_toggled"))
	confirmButton.connect("pressed", Callable(self, "_on_confirmButton_pressed"))
	backButton.connect("pressed", Callable(self, "_on_backButton_pressed"))

	# Connect button hover signals
	bgmusicButton.connect("mouse_entered", Callable(self, "_on_button_hovered"))
	sfxButton.connect("mouse_entered", Callable(self, "_on_button_hovered"))
	fullscreenButton.connect("mouse_entered", Callable(self, "_on_button_hovered"))
	confirmButton.connect("mouse_entered", Callable(self, "_on_button_hovered"))
	backButton.connect("mouse_entered", Callable(self, "_on_button_hovered"))

	# Initialize sliders with global values
	bgmusicSlider.value = Global.bgMusic
	sfxSlider.value = Global.soundEffects

	# Set slider editability based on enabled flags
	bgmusicSlider.editable = Global.bgMusicEnabled
	sfxSlider.editable = Global.soundEffectsEnabled
	
	Global.play_background_music()

func _on_bgmusicSlider_value_changed(value):
	Global.bgMusic = int(value)
	Global._apply_volume_settings_bgmusic()

func _on_sfxSlider_value_changed(value):
	Global.soundEffects = int(value)
	Global._apply_volume_settings_sfx()

func _on_bgmusicButton_toggled(toggled_on):
	Global.bgMusicEnabled = toggled_on
	bgmusicSlider.editable = toggled_on
	Global._apply_volume_settings_bgmusic()
	Global.button_click_sfx()

func _on_sfxButton_toggled(toggled_on):
	Global.soundEffectsEnabled = toggled_on
	sfxSlider.editable = toggled_on
	Global._apply_volume_settings_sfx()
	Global.button_click_sfx()

func _on_fullscreenButton_toggled(toggled_on):
	Global.fullscreen = toggled_on
	Global._apply_fullscreen_setting()
	Global.button_click_sfx()

func _on_confirmButton_pressed():
	Global.save_settings()
	Global.button_click_sfx()

func _on_backButton_pressed():
	Global.revert_settings()
	Global.button_click_sfx()
	get_tree().change_scene_to_file("res://main_menu_instructor.tscn")

func _on_button_hovered():
	Global.button_hover_sfx()
