extends Control

var description_text = {
	"quest_alone": "Let the adventure begin! Explore a world and play through levels fighting enemies. Testing your knowledge of English!",
	"quest_together": "Quest together lets you fight with other players against a strong boss! Work together to defeat it!"
}

@onready var description = $displaySide/simpleBox/description
@onready var questAloneButton = $buttonsSide/questAloneButton
@onready var questTogetherButton = $buttonsSide/questTogetherButton
@onready var backButton = $backButton

func _ready():
	# Connect button signals
	questAloneButton.connect("pressed", Callable(self, "_on_quest_alone_button_pressed"))
	questTogetherButton.connect("pressed", Callable(self, "_on_quest_together_button_pressed"))
	backButton.connect("pressed", Callable(self, "_on_back_button_pressed"))

	# Connect hover signals
	questAloneButton.connect("mouse_entered", Callable(self, "_on_quest_alone_button_hovered"))
	questTogetherButton.connect("mouse_entered", Callable(self, "_on_quest_together_button_hovered"))
	
	questAloneButton.connect("mouse_entered", Callable(self, "_on_button_hovered"))
	questTogetherButton.connect("mouse_entered", Callable(self, "_on_button_hovered"))
	backButton.connect("mouse_entered", Callable(self, "_on_button_hovered"))

func _on_quest_alone_button_pressed():
	get_tree().change_scene_to_file("res://Lore.tscn")
	Global.button_click_sfx()

func _on_quest_together_button_pressed():
	get_tree().change_scene_to_file("res://random_code_generator.tscn")
	Global.button_click_sfx()

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://main_menu_learner.tscn")
	Global.button_click_sfx()

func _on_quest_alone_button_hovered():
	description.text = description_text["quest_alone"]

func _on_quest_together_button_hovered():
	description.text = description_text["quest_together"]
	
func _on_button_hovered():
	Global.button_hover_sfx()
