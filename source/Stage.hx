package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Stage extends FlxSprite
{
    public static var STAGE_WIDTH:Int = 600;
    public static var STAGE_HEIGHT:Int = 8;

    public function new()
    {
        super();

        makeGraphic(STAGE_WIDTH, 
                    STAGE_HEIGHT, 
                    FlxColor.BLACK);
    }

    override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

	}

}