package;

class Attack {
    public var duration:Int;
    public var attackLag:Int;
    public var player:Player;
    public var hitboxes:Array<List<Hitbox>>;

    public var anchor:Float = 0;
    public var time:Int = 0;

    public function new(player:Player, 
                        duration:Int, 
                        attackLag:Int) {
        this.player = player;
        this.duration = duration;
        this.attackLag = attackLag;

        anchor = player.center();

        hitboxes = [for (i in 0...duration) (new List<Hitbox>())];
    }

    public function addHitbox(offset:Int, hitbox:Hitbox) {
        if (offset < 0 || offset >= duration) {
            throw "Invalid time offset for hitbox";
        }
        hitboxes[offset].add(hitbox);
    }

    public function alive():Bool {
        return (time < duration);
    }

    public function tick() {
        if (time >= duration) {
            return;
        }

        for (hitbox in hitboxes[time]) {
            hitbox.trigger();
        }

        time++;
    }
}

class JabAttack extends Attack {
    public static var JAB_DURATION = 4;
    public static var JAB_ATTACK_LAG = 10;

    public function new(player:Player) {
        super(player, JAB_DURATION, JAB_ATTACK_LAG);

        addHitbox(0, new Hitbox.JabHitbox(player, anchor));
    }
}

class SwordAttack extends Attack {
    public static var SWORD_DURATION = 15;
    public static var SWORD_ATTACK_LAG = 48;
    public static var SWORD_OFFSET = 0.07;

    public function new(player:Player) {
        super(player, SWORD_DURATION, SWORD_ATTACK_LAG);

        addHitbox(12, new Hitbox.SwordHitbox(player, player.face(SWORD_OFFSET)));
    }
}