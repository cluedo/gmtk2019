package;

class Hitbox {
    public static var FRAME_DURATION = 1./60;

    public var duration:Int;
    public var radius:Float = 0;
    public var strength:Float;
    public var hitstun:Int;
    public var animationLength:Int;

    public var time:Int = 0;
    public var active:Bool = false;
    
    public var player:Player;
    public var sprite:HitboxSprite;
    public var center:Float = 0;
    public var anchor:Float = 0;

    public function new(player:Player,
                        center:Float,
                        duration:Int,
                        radius:Float, 
                        strength:Float,
                        hitstun:Int,
                        animationLength:Int) {
        this.player = player;
        this.center = center;

        this.duration = duration;
        this.radius = radius;
        this.strength = strength;
        this.hitstun = hitstun;
        this.animationLength = animationLength;

        anchor = center;
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
                                  animationLength * FRAME_DURATION);
        PlayState.currentGame.activateHitbox(this);
    }
}

class JabHitbox extends Hitbox {
    public static var JAB_HITBOX_DURATION = 4;
    public static var JAB_HITBOX_RADIUS = 0.05;
    public static var JAB_HITBOX_STRENGTH = 0.5;
    public static var JAB_HITBOX_HITSTUN = 3;
    public static var JAB_HITBOX_ANIMATION = 10;


    public function new(player:Player,
                        center:Float) {
        super(player, center, 
              JAB_HITBOX_DURATION,
              JAB_HITBOX_RADIUS,
              JAB_HITBOX_STRENGTH,
              JAB_HITBOX_HITSTUN,
              JAB_HITBOX_ANIMATION);
    }
}

class SwordHitbox extends Hitbox {
    public static var SWORD_HITBOX_DURATION = 3;
    public static var SWORD_HITBOX_RADIUS = 0.05;
    public static var SWORD_HITBOX_STRENGTH = 0.8;
    public static var SWORD_HITBOX_HITSTUN = 40;
    public static var SWORD_HITBOX_ANIMATION = 40;

    public function new(player:Player,
                        center:Float) {
        super(player, center, 
              SWORD_HITBOX_DURATION,
              SWORD_HITBOX_RADIUS,
              SWORD_HITBOX_STRENGTH,
              SWORD_HITBOX_HITSTUN,
              SWORD_HITBOX_ANIMATION);
        anchor = player.center();
    }
}