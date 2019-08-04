package;

class Hitbox {
    public static var FRAME_DURATION = 1./60;

    public var duration:Int;
    public var radius:Float = 0;
    public var strength:Float;
    public var center:Float = 0;

    public var time:Int = 0;
    public var active:Bool = false;
    
    public var player:Player;
    public var sprite:HitboxSprite;

    public function new(player:Player,
                        center:Float,
                        duration:Int,
                        radius:Float, 
                        strength:Float) {
        this.player = player;
        this.center = center;

        this.duration = duration;
        this.radius = radius;
        this.strength = strength;
    }

    public function kill() {
        time = duration;
    }

    public function alive():Bool {
        return (time < duration);
    }

    public function tick() {
        time++;
    }

    public function trigger() {
        sprite = new HitboxSprite(Math.round(Stage.toPixels(2 * radius)),
                                  Stage.toPixelsOffset(center - radius),
                                  duration * FRAME_DURATION);
        PlayState.currentGame.activateHitbox(this);
    }
}

class JabHitbox extends Hitbox {
    public static var JAB_HITBOX_DURATION = 4;
    public static var JAB_HITBOX_RADIUS = 0.05;
    public static var JAB_HITBOX_STRENGTH = 0.5;

    public function new(player:Player,
                        center:Float) {
        super(player, center, 
              JAB_HITBOX_DURATION,
              JAB_HITBOX_RADIUS,
              JAB_HITBOX_STRENGTH);
    }
}