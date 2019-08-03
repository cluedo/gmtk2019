package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

import openfl.display.BitmapData;

class StageSprite extends FlxSprite
{
    public static var STAGE_WIDTH:Int = 600;
    public static var STAGE_HEIGHT:Int = 8;

    public static var PIXEL_WIDTH:Float = 1.0/STAGE_WIDTH;

    public var game:Game;

    public var spritePixels:BitmapData;

    public function new(game:Game)
    {
        super();

        this.game = game;

        makeGraphic(STAGE_WIDTH, 
                    STAGE_HEIGHT, 
                    FlxColor.BLACK);
    }

    override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        pixels.lock();
        for (x in 0...STAGE_WIDTH) {
            var color:FlxColor = game.render(x * PIXEL_WIDTH);
            for (y in 0...STAGE_HEIGHT) {
                pixels.setPixel(x, y, color);
            }
        //    FlxSpriteUtil.drawLine(this, x, 0, x, STAGE_HEIGHT,
        //    { color : color, thickness : 1});
        }
        pixels.unlock();

	}

}