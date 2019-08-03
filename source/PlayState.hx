package;

import flixel.FlxState;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	public var stage:Stage;

	public var player1:Player;
	public var player2:Player;

	override public function create():Void
	{
		super.create();

		bgColor = FlxColor.WHITE;

		stage = new Stage();
		add(stage);
		stage.screenCenter();

		player1 = new Player(stage, 20);
		add(player1);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
