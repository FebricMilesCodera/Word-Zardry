using Godot;
using System;

public partial class SplashScreen : Control
{

	public override void _Ready()
	{
		GetNode<Timer>("Timer").Timeout +=
			() => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("login.tscn");
	}
}
