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

		player1 = new Player(stage,
							 Player.PlayerType.PLAYER_ONE,
							 Player.InputType.KEYBOARD_ONE);
		add(player1);

		player2 = new Player(stage,
							 Player.PlayerType.PLAYER_TWO,
							 Player.InputType.KEYBOARD_TWO);
		add(player2);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
