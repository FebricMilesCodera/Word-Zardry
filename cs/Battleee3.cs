using Godot;
using System;

public partial class Battleee3 : Control
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	GetNode<Button>("Back").Pressed +=
        () => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("map_levels.tscn");
	}
}
