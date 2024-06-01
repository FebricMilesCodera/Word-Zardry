extends Control

@onready var classImage = $Control/simpleBox/mainContainer/classInfoContainer/classImage
@onready var classNameLabel = $Control/simpleBox/mainContainer/classInfoContainer/descriptionContainer/classNameLabel
@onready var classStoryLabel = $Control/simpleBox/mainContainer/classInfoContainer/descriptionContainer/classStoryLabel
@onready var confirmButton = $Control/simpleBox/mainContainer/buttonContainer/confirmButton

@onready var warriorEmblem = $Control/simpleBox/mainContainer/emblemsContainer/warriorEmblem
@onready var hunterEmblem = $Control/simpleBox/mainContainer/emblemsContainer/hunterEmblem
@onready var mageEmblem = $Control/simpleBox/mainContainer/emblemsContainer/mageEmblem
@onready var priestEmblem = $Control/simpleBox/mainContainer/emblemsContainer/priestEmblem

var selectedClass = ""
var chosen_class = Global.chosen_class

func _ready():
	warriorEmblem.connect("pressed", Callable(self, "_on_warrior_emblem_pressed"))
	hunterEmblem.connect("pressed", Callable(self, "_on_hunter_emblem_pressed"))
	mageEmblem.connect("pressed", Callable(self, "_on_mage_emblem_pressed"))
	priestEmblem.connect("pressed", Callable(self, "_on_priest_emblem_pressed"))
	confirmButton.connect("pressed", Callable(self, "_on_confirm_button_pressed"))

	print("Fetching data for chosen class:", chosen_class)
	update_class_info(chosen_class)

func update_class_info(chosen_class):
	var class_info = Global.classData[chosen_class]
	if class_info:
		classNameLabel.text = class_info.name
		classStoryLabel.text = class_info.description
		classImage.texture = load(class_info.imagePath)
	else:
		print("No class data found for chosen class:", chosen_class)

func _on_warrior_emblem_pressed():
	selectedClass = "Warrior"
	update_class_info(selectedClass)
	Global.button_click_sfx()

func _on_hunter_emblem_pressed():
	selectedClass = "Hunter"
	update_class_info(selectedClass)
	Global.button_click_sfx()

func _on_mage_emblem_pressed():
	selectedClass = "Mage"
	update_class_info(selectedClass)
	Global.button_click_sfx()

func _on_priest_emblem_pressed():
	selectedClass = "Priest"
	update_class_info(selectedClass)
	Global.button_click_sfx()

func _on_confirm_button_pressed():
	print("You have chosen:", selectedClass)
	get_tree().change_scene_to_file("res://room_ready.tscn")
	Global.button_click_sfx()
	
func _on_button_hovered():
	Global.button_hover_sfx()
	
func _on_Back_pressed():
	get_tree().change_scene_to_file("res://personality_quiz.tscn")
