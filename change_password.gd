extends Control

@onready var http_request = $HTTPRequest
@onready var email_label = $Control/simpleBox/email
@onready var password_label = $Control/simpleBox/password
@onready var confirm_password_label = $Control/simpleBox/confirmPassword
@onready var email_txt = $Control/simpleBox/emailTxt
@onready var password_txt = $Control/simpleBox/passwordTxt
@onready var confirm_password_txt = $Control/simpleBox/confirmPasswordTxt
@onready var confirm_button = $Control/simpleBox/confirmButton
@onready var change_password_button = $Control/simpleBox/changePasswordButton
@onready var message_label = $Control/simpleBox/messageLabel
@onready var info_label = $Control/simpleBox/info
@onready var back_button = $backButton

const firebaseConfig = {
	"apiKey": "AIzaSyCGmhW-nwWOHhQ8SMa-4Hl7YF-5IM2sB9c",
	"authDomain": "word-zardry-users.firebaseapp.com",
	"projectId": "word-zardry-users",
	"storageBucket": "word-zardry-users.appspot.com",
	"messagingSenderId": "880400877346",
	"appId": "1:880400877346:web:ab52b9326f7d75b643077b",
	"measurementId": "G-7W0SFQ4GCD"
}

var user_doc_path = ""
var default_message_color = Color(1, 0, 0)

func _ready():
	_hide_password_fields()
	_hide_message_label()
	confirm_button.connect("pressed", Callable(self, "_on_confirm_button_pressed"))
	change_password_button.connect("pressed", Callable(self, "_on_change_password_button_pressed"))
	back_button.connect("pressed", Callable(self, "_on_back_button_pressed"))
	
	confirm_button.connect("mouse_entered", Callable(self, "_on_button_hovered"))
	change_password_button.connect("mouse_entered", Callable(self, "_on_button_hovered"))
	back_button.connect("mouse_entered", Callable(self, "_on_button_hovered"))

func _hide_password_fields():
	password_label.visible = false
	confirm_password_label.visible = false
	password_txt.visible = false
	confirm_password_txt.visible = false
	change_password_button.visible = false

func _show_password_fields():
	password_label.visible = true
	confirm_password_label.visible = true
	password_txt.visible = true
	confirm_password_txt.visible = true
	change_password_button.visible = true

func _hide_email_fields():
	email_label.visible = false
	email_txt.visible = false
	confirm_button.visible = false

func _show_email_fields():
	email_label.visible = true
	email_txt.visible = true
	confirm_button.visible = true

func _hide_message_label():
	message_label.visible = false

func _show_message_label(text: String, color: Color = default_message_color):
	message_label.text = text
	message_label.modulate = color
	message_label.visible = true

func _on_http_request_request_completed(result, response_code, headers, body):
	print("Request completed with response code: %d" % response_code)
	http_request.disconnect("request_completed", Callable(self, "_on_http_request_request_completed"))

	if response_code == 200:
		var response = JSON.parse_string(body.get_string_from_utf8())
		print("Response: %s" % body.get_string_from_utf8())  # Print the response body for debugging
		if typeof(response) == TYPE_ARRAY:
			var email_found = false
			for document in response:
				if document.has("document"):
					var fields = document["document"]["fields"]
					if fields.has("Email") and fields["Email"]["stringValue"] == email_txt.text:
						email_found = true
						user_doc_path = document["document"]["name"]
						break
			
			if email_found:
				print("Email found: %s" % email_txt.text)
				_hide_email_fields()
				_show_password_fields()
				info_label.text = "Enter a new password"	
				message_label.text = ""
			else:
				print("Email not found")
				_show_message_label("Email not found")
		else:
			print("Unexpected response format")
			_show_message_label("Unexpected response format")
	else:
		print("HTTP request failed with response code: %d" % response_code)
		_show_message_label("Error: %d" % response_code)

func _on_confirm_button_pressed():
	print("Confirm button pressed")
	Global.button_click_sfx()
	var email = email_txt.text
	print("Email entered: %s" % email)
	if email == "":
		_show_message_label("Enter an email")
		return

	var url = "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents:runQuery" % firebaseConfig["projectId"]
	var query = {
		"structuredQuery": {
			"where": {
				"fieldFilter": {
					"field": { "fieldPath": "Email" },
					"op": "EQUAL",
					"value": { "stringValue": email }
				}
			},
			"from": [{ "collectionId": "Users" }],
			"limit": 1
		}
	}
	print("Sending HTTP request to: %s" % url)
	http_request.connect("request_completed", Callable(self, "_on_http_request_request_completed"))
	http_request.request(url, ['Content-Type: application/json'], HTTPClient.METHOD_POST, JSON.stringify(query))

func _on_change_password_button_pressed():
	print("Change password button pressed")
	Global.button_click_sfx()
	var password = password_txt.text
	var confirm_password = confirm_password_txt.text

	if password == "" or confirm_password == "":
		_show_message_label("Enter the fields")
		return

	if password != confirm_password:
		_show_message_label("Passwords do not match")
		return

	var url = "https://firestore.googleapis.com/v1/%s?updateMask.fieldPaths=Password" % user_doc_path
	var update_data = {
		"fields": {
			"Password": { "stringValue": password }
		}
	}
	print("Sending password change request to: %s" % url)
	http_request.connect("request_completed", Callable(self, "_on_password_change_completed"))
	http_request.request(url, ['Content-Type: application/json'], HTTPClient.METHOD_PATCH, JSON.stringify(update_data))

func _on_password_change_completed(result, response_code, headers, body):
	print("Password change request completed with response code: %d" % response_code)
	http_request.disconnect("request_completed", Callable(self, "_on_password_change_completed"))

	if response_code == 200:
		_show_message_label("Password changed", Color(1, 1, 1))
		await get_tree().create_timer(2).timeout
		_hide_password_fields()
		_show_email_fields()
		info_label.text = "Please enter your username"
		message_label.visible = false
		# Reset the message label to default color (red) after the timeout
		message_label.modulate = default_message_color
	else:
		_show_message_label("Error: %d" % response_code)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://login.tscn")
	Global.button_click_sfx()
	
func _on_button_hovered():
	Global.button_hover_sfx()
