package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Hitbox extends FlxSprite {
    public var activeDuration:Float;
    public var totalDuration:Float;

    public var age:Float;

    public var player:Player;

    public function new(player:Player, width:Float, xCoordinate:Float, totalDuration:Float, activeDuration:Float, knockback:Float, color:FlxColor) {
        super();

        this.activeDuration = activeDuration;
        this.totalDuration = totalDuration;
        this.age = 0;

        makeGraphic(width, Stage.STAGE_HEIGHT, color);
        x = xCoordinate;
        y = player.y;
    }

    override public function update(elapsed:Float):Void {
		super.update(elapsed);

        x = FlxMath.bound(x, stage.x, stage.x + Stage.STAGE_WIDTH - PLAYER_WIDTH);
	}
}