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

		player1 = new Player(stage, 20, true);
		add(player1);

        player2 = new Player(stage, 300, false);
		add(player2);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
