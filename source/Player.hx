package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
    public static var PLAYER_SIZE:Float = 0.05;
    public static var PLAYER_WIDTH:Int = 
        Math.round(PLAYER_SIZE * Stage.STAGE_WIDTH);
    public static var PLAYER_HEIGHT:Int = Stage.STAGE_HEIGHT;

    public var stage:Stage;
    public var game:PlayState;

    public var speed:Float = 0;

    public function new(stage:Stage, ?X:Float=0)
    {
        super();

        this.stage = stage;

        makeGraphic(PLAYER_WIDTH, 
                    PLAYER_HEIGHT, 
                    FlxColor.RED);

        x = stage.x + X;
        y = stage.y;
    }

    override public function update(elapsed:Float):Void
	{
        movement();
		super.update(elapsed);

        x = FlxMath.bound(x, stage.x, stage.x + Stage.STAGE_WIDTH - PLAYER_WIDTH);
	}

    public function movement():Void
    {
        // adapted from http://haxeflixel.com/documentation/groundwork/
        var left:Bool = false;
        var right:Bool = false;

        left = FlxG.keys.anyPressed([LEFT]);
        right = FlxG.keys.anyPressed([RIGHT]);


        if (left) {
            speed = -100;
        } else if (right) {
            speed = 100;
        } else {
            speed = speed/2;
        }
        velocity.set(speed, 0);
    }

}