 using Godot;
using System;

public partial class MainMenu : Control
{
	private Control _pausePanel;
	public override void _Ready()
	{
		GetNode<Button>("Buttons/Play").Pressed +=
			() => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("main_menu_2.tscn");

		GetNode<Button>("Buttons/Options").Pressed +=
			() => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("options.tscn");
			
		GetNode<Button>("Buttons/LogOut").Pressed +=
			() => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("log_in.tscn");

		GetNode<Button>("VBoxContainer2/Updates").Pressed +=
			() => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("log_in.tscn");

		GetNode<Button>("Buttons/Profile").Pressed +=
			() => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("profile.tscn");

		GetNode<Button>("Buttons/Billing").Pressed +=
			() => GetNode<SceneLoader>("/root/SceneLoader").ChangetoScene("billing.tscn");

		_pausePanel = GetNode<Control>("pausePanel");
		_pausePanel.Hide();
	}

public void ExitGamePause() 
	{
		GetTree().Paused = true;
		_pausePanel.Show();
		_pausePanel
			.GetNode<AnimationPlayer>("AnimationPlayer")
			.Play("start_pause");
	} 

	public void ExitGame() 
	{
		GetTree().Quit();
	}

	private void _Unpause()
	{
		GetTree().Paused = false;
		_pausePanel.Hide();
	}

}

