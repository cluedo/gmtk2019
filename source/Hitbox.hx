package;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class Hitbox extends FlxSprite {
    public var activeDuration:Float;
    public var totalDuration:Float;

    public var age:Float;
    public var isActive:Bool;

    public var player:Player;

    public var colorTween:FlxTween;

    public function new(player:Player, width:Int, xCoordinate:Float, totalDuration:Float, activeDuration:Float, knockback:Float = 0, color:FlxColor = FlxColor.LIME) {
        super();

        this.activeDuration = activeDuration;
        this.totalDuration = totalDuration;
        this.age = 0;
        this.isActive = true;

        makeGraphic(width, Stage.STAGE_HEIGHT, color);
        x = xCoordinate;
        y = player.y;

        colorTween = FlxTween.tween(this, {alpha: 0.0}, totalDuration, {type: FlxTweenType.ONESHOT, ease: FlxEase.cubeInOut});
    }

    override public function update(elapsed:Float):Void {
		super.update(elapsed);

        age += elapsed;
        if (age > activeDuration) {
            isActive = false;
        }
        if (age > totalDuration) {
            visible = false;
        }
	}
}