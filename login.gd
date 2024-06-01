extends Control

@onready var http_request = $HTTPRequest
@onready var email_text = $Frame/emailTxt
@onready var password_text = $Frame/passwordTxt
@onready var message_label = $Frame/messageLabel
@onready var login_button = $Frame/loginButton
@onready var register_button = $Frame/RegisterClick
@onready var forgot_password_button = $Frame/forgotPassword
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

func _ready():
	login_button.connect("pressed", Callable(self, "_on_login_button_pressed"))
	login_button.connect("mouse_entered", Callable(self, "_on_button_hovered"))

	register_button.connect("pressed", Callable(self, "_on_register_click_pressed"))
	register_button.connect("mouse_entered", Callable(self, "_on_button_hovered"))

	forgot_password_button.connect("pressed", Callable(self, "_on_forgot_password_pressed"))
	forgot_password_button.connect("mouse_entered", Callable(self, "_on_button_hovered"))

	quit_button.connect("pressed", Callable(self, "_on_quit_button_pressed"))
	quit_button.connect("mouse_entered", Callable(self, "_on_button_hovered"))

func _on_login_button_pressed():
	var email = email_text.text
	var password = password_text.text
	if email == "" or password == "":
		message_label.text = "Please enter both email and password."
		message_label.visible = true
		Global.button_click_sfx()
		return

	var url = "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/Users" % firebaseConfig["projectId"]
	http_request.connect("request_completed", Callable(self, "_on_http_request_completed"))
	http_request.request(url)	
	Global.button_click_sfx()

func _on_http_request_completed(result, response_code, headers, body):
	http_request.disconnect("request_completed", Callable(self, "_on_http_request_completed"))

	if response_code == 200:
		var response = JSON.parse_string(body.get_string_from_utf8())
		if typeof(response) == TYPE_DICTIONARY and response.has("documents"):
			var documents = response["documents"]
			var email_found = false
			var password_matched = false
			var is_instructor = false
			for document in documents:
				var fields = document["fields"]
				if fields["Email"]["stringValue"] == email_text.text:
					email_found = true
					if fields["Password"]["stringValue"] == password_text.text:
						password_matched = true
						is_instructor = fields["isInstructor"]["booleanValue"]
						Global.username = fields["Username"]["stringValue"]  # Set the global username
						break

			if email_found and password_matched:
				message_label.visible = false
				if is_instructor:
					get_tree().change_scene_to_file("res://main_menu_instructor.tscn")
				else:
					get_tree().change_scene_to_file("res://main_menu_learner.tscn")
			else:
				message_label.text = "Invalid email or password."
				message_label.visible = true
		else:
			message_label.text = "Error parsing response."
			message_label.visible = true
	else:
		message_label.text = "HTTP request failed with response code: %d" % response_code
		message_label.visible = true

func _on_register_click_pressed():
	Global.button_click_sfx()
	get_tree().change_scene_to_file("res://register.tscn")

func _on_forgot_password_pressed():
	Global.button_click_sfx()
	get_tree().change_scene_to_file("res://change_password.tscn")

func _on_quit_button_pressed():
	Global.button_click_sfx()
	get_tree().quit()

func _on_button_hovered():
	Global.button_hover_sfx()
