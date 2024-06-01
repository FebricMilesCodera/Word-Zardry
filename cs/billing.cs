using Godot;
using System;

public partial class billing : Control
{

	public override void _Ready()
	{
	GetNode<Button>("Back").Pressed +=
        () => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("main_menu.tscn");

	GetNode<Button>("Confirm").Pressed +=
        () => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("billing_2.tscn");
	}
}
