using Godot;
using System;

public partial class room_ready : Control
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	
		GetNode<Button>("VBoxContainer2/Back").Pressed +=
            () => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("random_code_generator.tscn");

		GetNode<Button>("ReadyButton").Pressed +=
            () => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("BattleIns.tscn");
	}
}
