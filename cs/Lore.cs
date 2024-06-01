using Godot;
using System;

public partial class Lore : Control
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	GetNode<Button>("VBoxContainer2/Back").Pressed +=
            () => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("quest_options.tscn");

	GetNode<Button>("Next").Pressed +=
            () => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("map_levels.tscn");

	}
}
