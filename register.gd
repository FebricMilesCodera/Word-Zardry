extends Control

@onready var http_request = $HTTPRequest
@onready var username_text = $Frame/usernameTxt
@onready var email_text = $Frame/emailTxt
@onready var password_text = $Frame/passwordTxt
@onready var message_label = $Frame/errorLabel
@onready var instructor_button = $Frame/instructorButton
@onready var learner_button = $Frame/learnerButton
@onready var register_button = $Frame/registerButton
@onready var login_button = $Frame/loginClick
@onready var quit_button = $quitButton

const firebaseConfig = {
	"apiKey": "AIzaSyCGmhW-nwWOHhQ8SMa-4Hl7YF-5IM2sB9c",
	"authDomain": "word-zardry-users.firebaseapp.com",
	"projectId": "word-zardry-users",
	"storageBucket": "word-zardry-users.appspot.com",
	"messagingSenderId": "880400877346",
	"appId": "1:880400877346:web:ab52b9326f7d75b643077b",
	"measurementId": "G-7W0SFQ4GCD"
}

var selectedType: String = "" # Initialize with an empty string
var instructorButtonClicked: bool = false # Flag to track button state
var learnerButtonClicked: bool = false # Flag to track button state

func _ready():
	message_label.visible = false

	register_button.connect("mouse_entered", Callable(self, "_on_button_hovered"))
	login_button.connect("mouse_entered", Callable(self, "_on_button_hovered"))
	quit_button.connect("mouse_entered", Callable(self, "_on_button_hovered"))
	instructor_button.connect("mouse_entered", Callable(self, "_on_button_hovered"))
	learner_button.connect("mouse_entered", Callable(self, "_on_button_hovered"))

func _register_user(url: String, username: String, email: String, password: String, is_instructor: bool):
	var http = $HTTPRequest
	var jsonObject = JSON.new()
	var body = jsonObject.stringify({
		"fields": {
			"Username": {"stringValue": username},
			"Email": {"stringValue": email},
			"Password": {"stringValue": password},
			"isInstructor": {"booleanValue": is_instructor}
		}
	})
	var headers = ['Content-Type: application/json']
	http.request(url, headers, HTTPClient.METHOD_POST, body)

func _on_http_request_request_completed(result, response_code, headers, body):
	if response_code == 200:
		get_tree().change_scene_to_file("res://login.tscn")
	else:
		var response = JSON.parse_string(body.get_string_from_utf8())
		message_label.text = "Error: %s" % response.error.message
		message_label.visible = true
		username_text.placeholder_text = "required"
		email_text.placeholder_text = "required"
		password_text.placeholder_text = "required"
		

func _on_register_button_pressed():
	var username = username_text.text
	var email = email_text.text
	var password = password_text.text

	if username == "" or email == "" or password == "":
		message_label.text = "Please fill in all required fields."
		message_label.visible = true
		Global.button_click_sfx()
		return

	var is_instructor = instructorButtonClicked
	var url = "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/Users" % firebaseConfig["projectId"]
	http_request.connect("request_completed", Callable(self, "_on_http_request_request_completed"))
	_register_user(url, username, email, password, is_instructor)
	Global.button_click_sfx()

func _on_loginClick_pressed():
	get_tree().change_scene_to_file("res://login.tscn")
	Global.button_click_sfx()

func _on_quit_button_pressed():
	get_tree().quit()
	Global.button_click_sfx()

func _on_instructor_button_pressed():
	if not instructorButtonClicked:
		instructorButtonClicked = true
		learnerButtonClicked = false
		instructor_button.disabled = true
		learner_button.disabled = false
	else:
		instructorButtonClicked = false
		instructor_button.disabled = false
		
	Global.button_click_sfx()

func _on_learner_button_pressed():
	if not learnerButtonClicked:
		learnerButtonClicked = true
		instructorButtonClicked = false
		learner_button.disabled = true
		instructor_button.disabled = false
	else:
		learnerButtonClicked = false
		learner_button.disabled = false
	
	Global.button_click_sfx()

func _on_button_hovered():
	Global.button_hover_sfx()
