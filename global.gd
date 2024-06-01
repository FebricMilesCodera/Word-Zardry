extends Node

var username = ""
var chosen_class = ""

var bgMusic: int = 100
var soundEffects: int = 100
var fullscreen: bool = false

var bgMusicEnabled: bool = true
var soundEffectsEnabled: bool = true

var classData = {
	"Warrior": {
		"name": "Warrior",
		"description": "Warriors are brave and strong fighters.",
		"imagePath": "res://Sprites/warrior_sprite_final.png"
	},
	"Hunter": {
		"name": "Hunter",
		"description": "Hunters are stealthy and quick.",
		"imagePath": "res://Sprites/hunter_sprite_final.png"
	},
	"Mage": {
		"name": "Mage",
		"description": "Mages are wise and powerful with magic.",
		"imagePath": "res://Sprites/mage_sprite_final.png"
	},
	"Priest": {
		"name": "Priest",
		"description": "Priests are kind and heal the wounded.",
		"imagePath": "res://Sprites/priest_sprite_final.png"
	}
}

@onready var bgmusic_player = $bgmusic_player
@onready var sfx_player = $sfx_player

var initial_bgMusic: int
var initial_soundEffects: int
var initial_bgMusicEnabled: bool
var initial_soundEffectsEnabled: bool
var initial_fullscreen: bool

func _ready():
	# Store initial settings to allow reverting if necessary
	initial_bgMusic = bgMusic
	initial_soundEffects = soundEffects
	initial_bgMusicEnabled = bgMusicEnabled
	initial_soundEffectsEnabled = soundEffectsEnabled
	initial_fullscreen = fullscreen
	
	# Apply initial settings
	_apply_volume_settings_bgmusic()
	_apply_volume_settings_sfx()
	_apply_fullscreen_setting()
	play_background_music()

func _apply_volume_settings_bgmusic():
	var bgmusic_volume = (bgMusic * 0.01 * 24 - 24) if bgMusicEnabled else -80
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), bgmusic_volume)

func _apply_volume_settings_sfx():
	var sfx_volume = (soundEffects * 0.01 * 24 - 24) if soundEffectsEnabled else -80
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfx_volume)

func _apply_fullscreen_setting():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)

func button_click_sfx():
	if soundEffectsEnabled and sfx_player:
		sfx_player.stream = load("res://Sound Effects/buttonClick.mp3")
		sfx_player.play()
		print("Button click sound effect played")
	else:
		print("Button click sound effect not played due to disabled sound effects or missing audio player")

func button_hover_sfx():
	if soundEffectsEnabled and sfx_player:
		sfx_player.stream = load("res://Sound Effects/buttonHover.mp3")
		sfx_player.play()
		print("Button hover sound effect played")
	else:
		print("Button hover sound effect not played due to disabled sound effects or missing audio player")

func save_settings():
	initial_bgMusic = bgMusic
	initial_soundEffects = soundEffects
	initial_bgMusicEnabled = bgMusicEnabled
	initial_soundEffectsEnabled = soundEffectsEnabled
	initial_fullscreen = fullscreen
	print("Settings saved")

func revert_settings():
	bgMusic = initial_bgMusic
	soundEffects = initial_soundEffects
	bgMusicEnabled = initial_bgMusicEnabled
	soundEffectsEnabled = initial_soundEffectsEnabled
	fullscreen = initial_fullscreen
	_apply_volume_settings_bgmusic()
	_apply_volume_settings_sfx()
	_apply_fullscreen_setting()
	play_background_music()
	print("Settings reverted")

func play_background_music():
	if bgMusicEnabled and bgmusic_player:
		if not bgmusic_player.playing:
			bgmusic_player.stream = load("res://Music/Main Menu.mp3")
			bgmusic_player.play()
			print("Background music playing")
	else:
		bgmusic_player.stop()
		print("Background music stopped")
