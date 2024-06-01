using Godot;
using System;

public partial class profile : Control
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	GetNode<Button>("Back").Pressed +=
            () => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("main_menu.tscn");


	GetNode<Button>("Change Class").Pressed +=
        () => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("personality_quiz.tscn");


	GetNode<Button>("Change Password").Pressed +=
            () => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("forgot_password.tscn");


	}
}
