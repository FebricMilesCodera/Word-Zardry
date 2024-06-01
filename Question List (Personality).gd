extends Control

@onready var http_request = $HTTPRequest
@onready var updateButton = $CenterContainer/SimpleBox/updateButton
@onready var backButton = $backButton
@onready var savingLabel = $savingLabel

# Arrays to hold references to question and answer TextEdits and LineEdits
var questionTextEdits = []
var answer1LineEdits = []
var answer2LineEdits = []
var answer3LineEdits = []
var answer4LineEdits = []

# Variable to track the current question index during fetching and updating
var current_fetch_index = 0
var current_update_index = 0

const firebaseConfig = {
	"apiKey": "AIzaSyCGmhW-nwWOHhQ8SMa-4Hl7YF-5IM2sB9c",
	"authDomain": "word-zardry-users.firebaseapp.com",
	"projectId": "word-zardry-users",
	"storageBucket": "word-zardry-users.appspot.com",
	"messagingSenderId": "880400877346",
	"appId": "1:880400877346:web:ab52b9326f7d75b643077b",
	"measurementId": "G-7W0SFQ4GCD"
}

func _ready():
	http_request.connect("request_completed", Callable(self, "_on_HTTPRequest_request_completed"))
	updateButton.connect("pressed", Callable(self, "_on_updateButton_pressed"))
	backButton.connect("pressed", Callable(self, "_on_back_button_pressed"))
	
	updateButton.connect("mouse_entered", Callable(self, "_on_button_hovered"))
	backButton.connect("mouse_entered", Callable(self, "_on_button_hovered"))
	
	savingLabel.visible = false
	# Populate the arrays with the nodes
	for i in range(1, 11): # Assuming you have 10 questions
		questionTextEdits.append($CenterContainer/SimpleBox/ScrollContainer/questionLists.get_node("question%d/Panel/mainContainer/questionContainer/questionTextMargin/questionTextEdit%d" % [i, i]))
		answer1LineEdits.append($CenterContainer/SimpleBox/ScrollContainer/questionLists.get_node("question%d/Panel/mainContainer/choicesContainer/choicesMargin/choicesContainer/answer1LineEdit%d" % [i, i]))
		answer2LineEdits.append($CenterContainer/SimpleBox/ScrollContainer/questionLists.get_node("question%d/Panel/mainContainer/choicesContainer/choicesMargin/choicesContainer/answer2LineEdit%d" % [i, i]))
		answer3LineEdits.append($CenterContainer/SimpleBox/ScrollContainer/questionLists.get_node("question%d/Panel/mainContainer/choicesContainer/choicesMargin/choicesContainer/answer3LineEdit%d" % [i, i]))
		answer4LineEdits.append($CenterContainer/SimpleBox/ScrollContainer/questionLists.get_node("question%d/Panel/mainContainer/choicesContainer/choicesMargin/choicesContainer/answer4LineEdit%d" % [i, i]))

	fetch_questions()

func fetch_questions():
	current_fetch_index = 0
	request_question(current_fetch_index)

func request_question(index):
	var collection = "Question List (Personality)".replace(" ", "%20")
	var document = "Question%d" % (index + 1)
	var url = "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/%s/%s" % [firebaseConfig["projectId"], collection, document]
	print("Fetching questions from: ", url)
	http_request.request(url)

func _on_HTTPRequest_request_completed(_result, response_code, _headers, body):
	print("Request completed with response code: ", response_code)
	var response_text = body.get_string_from_utf8()
	print("Response body: ", response_text)
	
	if response_code == 200:
		var json_parser = JSON.new()
		var parse_error = json_parser.parse(response_text)
		if parse_error == OK:
			var parsed_data = json_parser.get_data()
			print("Parsed data: ", parsed_data)
			update_ui(parsed_data, current_fetch_index)
		else:
			print("JSON parse error: ", parse_error)
	else:
		print("Error fetching data: ", response_code)

	# Move to the next question
	current_fetch_index += 1
	if current_fetch_index < 10: # Fetch up to 10 questions
		request_question(current_fetch_index)

func update_ui(data, index):
	print("Data received in update_ui: ", data)
	if typeof(data) == TYPE_DICTIONARY and "fields" in data:
		var fields = data["fields"]
		print("Fields: ", fields)
		if "Question" in fields:
			questionTextEdits[index].text = fields["Question"]["stringValue"]
			print("Set question: ", fields["Question"]["stringValue"])
		if "Warrior" in fields:
			answer1LineEdits[index].text = fields["Warrior"]["stringValue"]
			print("Set Warrior: ", fields["Warrior"]["stringValue"])
		if "Hunter" in fields:
			answer2LineEdits[index].text = fields["Hunter"]["stringValue"]
			print("Set Hunter: ", fields["Hunter"]["stringValue"])
		if "Mage" in fields:
			answer3LineEdits[index].text = fields["Mage"]["stringValue"]
			print("Set Mage: ", fields["Mage"]["stringValue"])
		if "Priest" in fields:
			answer4LineEdits[index].text = fields["Priest"]["stringValue"]
			print("Set Priest: ", fields["Priest"]["stringValue"])
	else:
		print("Data format error or 'fields' not found in data.")

func _on_updateButton_pressed():
	print("Update button pressed")
	savingLabel.visible = true
	current_update_index = 0
	update_next_question()

func update_next_question():
	if current_update_index < 10: # Update up to 10 questions
		# Get the text from the UI elements
		var questionText = questionTextEdits[current_update_index].text
		var warriorText = answer1LineEdits[current_update_index].text
		var hunterText = answer2LineEdits[current_update_index].text
		var mageText = answer3LineEdits[current_update_index].text
		var priestText = answer4LineEdits[current_update_index].text

		# Prepare the data to be sent to Firestore
		var data = {
			"Question": { "stringValue": questionText },
			"Warrior": { "stringValue": warriorText },
			"Hunter": { "stringValue": hunterText },
			"Mage": { "stringValue": mageText },
			"Priest": { "stringValue": priestText }
		}

		# Update the data in Firestore
		update_firestore(data, current_update_index + 1)
	else:
		savingLabel.visible = false
		print("All questions updated")

func update_firestore(data, question_index):
	var collection = "Question List (Personality)".replace(" ", "%20")
	var document = "Question%d" % question_index  # Updating the appropriate question
	var url = "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/%s/%s" % [firebaseConfig["projectId"], collection, document]

	# Prepare the request body
	var body = {
		"fields": data
	}

	# Convert body to JSON string
	var json = JSON.stringify(body)

	# Prepare the request headers
	var headers = ["Content-Type: application/json"]

	# Send the update request
	http_request.disconnect("request_completed", Callable(self, "_on_HTTPRequest_request_completed"))
	http_request.connect("request_completed", Callable(self, "_on_update_request_completed").bind(question_index))
	http_request.request(url, headers, HTTPClient.METHOD_PATCH, json)
	print("Updating data in Firestore for Question %d..." % question_index)

func _on_update_request_completed(result, response_code, headers, body, question_index):
	print("Update request completed for Question %d with response code: %d" % [question_index, response_code])
	
	# Move to the next question
	current_update_index += 1
	update_next_question()

func _on_back_button_pressed():
	Global.button_click_sfx()
	get_tree().change_scene_to_file("res://random_code_generator.tscn")
	
func _on_button_hovered():
	Global.button_hover_sfx()
