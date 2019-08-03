package;

import flixel.FlxState;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	public var stage:StageSprite;
	public var game:Game;

	override public function create():Void
	{
		super.create();

		bgColor = FlxColor.WHITE;

		game = new Game();

		stage = new StageSprite(game);
		add(stage);

		stage.screenCenter();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
