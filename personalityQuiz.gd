extends Node

@onready var http_request = $HTTPRequest
@onready var question_label = $Control/questionLabel
@onready var answer_button1 = $Control/answerButton1
@onready var answer_button2 = $Control/answerButton2
@onready var answer_button3 = $Control/answerButton3
@onready var answer_button4 = $Control/answerButton4

@onready var loadingLabel = $loadingLabel

# Firebase configuration
var firebaseConfig = {
	"apiKey": "AIzaSyCGmhW-nwWOHhQ8SMa-4Hl7YF-5IM2sB9c",
	"authDomain": "word-zardry-users.firebaseapp.com",
	"projectId": "word-zardry-users",
	"storageBucket": "word-zardry-users.appspot.com",
	"messagingSenderId": "880400877346",
	"appId": "1:880400877346:web:ab52b9326f7d75b643077b",
	"measurementId": "G-7W0SFQ4GCD"
}

var questions = []
var current_question_index = 0
var points = {
	"Warrior": 0,
	"Hunter": 0,
	"Mage": 0,
	"Priest": 0
}

func _ready():
	http_request.connect("request_completed", Callable(self, "_on_HTTPRequest_request_completed"))
	loadingLabel.visible = true
	fetch_questions()

func fetch_questions() -> void:
	questions.clear()
	current_question_index = 0
	points = {
		"Warrior": 0,
		"Hunter": 0,
		"Mage": 0,
		"Priest": 0
	}
	# Sequentially fetch questions
	for i in range(1, 11):
		await fetch_question(i)
	show_question(current_question_index)

func fetch_question(index) -> void:
	var collection = "Question List (Personality)".replace(" ", "%20")
	var document = "Question%d" % index
	var url = "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/%s/%s" % [firebaseConfig["projectId"], collection, document]
	print("Fetching questions from: ", url)
	http_request.request(url)
	await http_request.request_completed
	print("Question %d fetched" % index)

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print("Request completed with response code: ", response_code)
	var response_text = body.get_string_from_utf8()
	print("Response body: ", response_text)

	if response_code == 200:
		var json_parser = JSON.new()
		var parse_error = json_parser.parse(response_text)
		if parse_error == OK:
			var parsed_data = json_parser.get_data()
			print("Parsed data: ", parsed_data)
			add_question(parsed_data)
		else:
			print("JSON parse error: ", parse_error)
	else:
		print("Error fetching data: ", response_code)

func add_question(data):
	if typeof(data) == TYPE_DICTIONARY and "fields" in data:
		var fields = data["fields"]
		questions.append(fields)
		print("Questions size: ", questions.size())

func show_question(index):
	if index < questions.size():
		var question_data = questions[index]
		question_label.text = question_data["Question"]["stringValue"]
		answer_button1.text = question_data["Warrior"]["stringValue"]
		answer_button2.text = question_data["Hunter"]["stringValue"]
		answer_button3.text = question_data["Mage"]["stringValue"]
		answer_button4.text = question_data["Priest"]["stringValue"]
		loadingLabel.visible = false
	else:
		determine_class()

func determine_class():
	for className in points.keys():
		print(className, "points:", points[className])
	var max_points = -1
	var selected_classes = []
	for className in points.keys():
		if points[className] > max_points:
			max_points = points[className]
			selected_classes = [className]
		elif points[className] == max_points:
			selected_classes.append(className)
	var chosen_class = selected_classes[randi() % selected_classes.size()]
	print("Chosen class: ", chosen_class)
	Global.chosen_class = chosen_class
	change_to_results_scene()

func _on_answer_button_1_pressed():
	points["Warrior"] += 1
	next_question()
	Global.button_click_sfx()

func _on_answer_button_2_pressed():
	points["Hunter"] += 1
	next_question()
	Global.button_click_sfx()

func _on_answer_button_3_pressed():
	points["Mage"] += 1
	next_question()
	Global.button_click_sfx()

func _on_answer_button_4_pressed():
	points["Priest"] += 1
	next_question()
	Global.button_click_sfx()

func next_question():
	current_question_index += 1
	if current_question_index < questions.size():
		show_question(current_question_index)
	else:
		determine_class()

func change_to_results_scene():
	print("Changing to results scene")
	get_tree().change_scene_to_file("res://personality_result.tscn")
	
func _on_button_hovered():
	Global.button_hover_sfx()

func _on_Back_pressed():
	get_tree().change_scene_to_file("res://random_code_generator.tscn")
