package;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class HitboxSprite extends FlxSprite {
    public var duration:Float;

    public var age:Float;
    public var isActive:Bool;

    public var colorTween:FlxTween;

    public function new(width:Int, 
                        x:Float, 
                        duration:Float, 
                        color:FlxColor = FlxColor.LIME) {
        super();

        this.duration = duration;
        this.age = 0;
        this.isActive = true;

        makeGraphic(width, Stage.STAGE_HEIGHT, color);
        this.x = x;
        y = Stage.currentStage.y;

        colorTween = FlxTween.tween(this, 
                                    {alpha: 0.0}, 
                                    duration, 
                                    {type: FlxTweenType.ONESHOT, 
                                     ease: FlxEase.cubeInOut});
    }

    override public function update(elapsed:Float):Void {
		super.update(elapsed);

        age += elapsed;
        if (age > duration) {
            visible = false;
        }
	}
}