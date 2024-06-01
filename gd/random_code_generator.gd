extends Control

@onready var code_line_edit = $LineEdit
@onready var apply_button = $Button

func _ready():
	print("code_line_edit: ", code_line_edit)
	print("apply_button: ", apply_button)
	grab_focus()
	
	randomize()
	
	if apply_button:
		apply_button.connect("pressed", Callable(self, "_on_apply_button_pressed"))
	else:
		print("Error: apply_button is null")

func _on_apply_button_pressed():
	var random_code = _generate_random_code()
	code_line_edit.text = random_code
	
func _on_Back_pressed():
	get_tree().change_scene_to_file("res://quest_options.tscn")
	
func _on_QuestionListButton_pressed():
	get_tree().change_scene_to_file("res://question_list_(personality).tscn")
	
func _on_PersonalityQuizButton_pressed():
	get_tree().change_scene_to_file("res://personality_quiz.tscn")
	
func _on_CreateRoomButton_pressed():
	get_tree().change_scene_to_file("res://room_ready.tscn")

func _generate_random_code(length: int = 15) -> String:
	var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	var code = ""
	for i in range(length):
		var random_index = randi() % chars.length()
		code += chars[random_index]
	return code
