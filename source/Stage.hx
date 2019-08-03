package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Stage extends FlxSprite
{
    public static var STAGE_WIDTH:Int = 600;
    public static var STAGE_HEIGHT:Int = 8;

    public static var currentStage:Stage;

    public static function toPixels(w:Float):Float {
        return STAGE_WIDTH * w;
    }

    public static function toPixelsOffset(w:Float):Float {
        return toPixels(w) + currentStage.x;
    }

    public static function toUnits(w:Float) {
        return w / STAGE_WIDTH;
    }

    public static function toUnitsOffset(w:Float) {
        return toUnits(w - currentStage.x);
    }

    public function new()
    {
        super();

        makeGraphic(STAGE_WIDTH, 
                    STAGE_HEIGHT, 
                    FlxColor.BLACK);

        currentStage = this;
    }

    override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

	}

}