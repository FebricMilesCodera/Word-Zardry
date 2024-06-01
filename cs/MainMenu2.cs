 using Godot;
using System;

public partial class MainMenu2 : Control
{

	public override void _Ready()
	{
		GetNode<Button>("VBoxContainer2/Back").Pressed +=
            () => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("main_menu.tscn");

			GetNode<Button>("Control/Quest Together").Pressed +=
            () => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("random_code_generator.tscn");

			GetNode<Button>("Control/Quest Alone").Pressed +=
            () => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("map_levels.tscn");
	}
}
 