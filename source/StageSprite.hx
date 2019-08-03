package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class StageSprite extends FlxSprite
{
    public static var STAGE_WIDTH:Int = 600;
    public static var STAGE_HEIGHT:Int = 16;

    public static var PIXEL_WIDTH:Float = 1.0/STAGE_WIDTH;

    public var game:Game;

    public function new(game:Game)
    {
        super();

        this.game = game;

        makeGraphic(STAGE_WIDTH, 
                    STAGE_HEIGHT, 
                    FlxColor.BLACK);

        var lineStyle:LineStyle = { color : FlxColor.RED, thickness: 1};
    }

    override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        for (x in 0...STAGE_WIDTH) {
            var color:FlxColor = game.render(x * PIXEL_WIDTH);
            FlxSpriteUtil.drawLine(this, x, 0, x, STAGE_HEIGHT,
            { color : color, thickness : 1});
        }

	}

}