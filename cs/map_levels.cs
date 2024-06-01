using Godot;
using System;

public partial class map_levels : Control
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GetNode<Button>("VBoxContainer2/Back").Pressed +=
            () => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("Lore.tscn");

		GetNode<Button>("Levels/Level 1").Pressed +=
            () => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("Battle.tscn");

		
		GetNode<Button>("Levels/Level 2").Pressed +=
            () => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("Battlee2.tscn");

		
		GetNode<Button>("Levels/Level 3").Pressed +=
            () => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("Battleee3.tscn");

		
		GetNode<Button>("Levels/Level 4").Pressed +=
            () => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("Battleeee4.tscn");

		GetNode<Button>("Levels/Level 5").Pressed +=
            () => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("Battleeeee5.tscn");
	}
}
