package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Hitbox extends FlxSprite {
    public var duration:Float
    public var currentDuration:Float;

    public function new(width:Float, xCoordinate:Float, duration:Float, strength:Float, color:FlxColor) {
        this.duration = duration;
        this.currentDuration = duration;
    }

    override public function update(elapsed:Float):Void {
		super.update(elapsed);

        x = FlxMath.bound(x, stage.x, stage.x + Stage.STAGE_WIDTH - PLAYER_WIDTH);
	}
}