package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	public static var currentGame:PlayState;

	public var stage:Stage;

	public var player1:Player;
	public var player2:Player;

	public var activeHitboxes:List<Hitbox>;

	override public function create() {
		super.create();
		currentGame = this;

		bgColor = FlxColor.WHITE;

		stage = new Stage();
		add(stage);
		stage.screenCenter();

		player1 = new Player(stage,
							 Player.PlayerType.PLAYER_ONE,
							 Player.InputType.KEYBOARD_ONE);
		add(player1);
		add(player1.arrowSprite);

		player2 = new Player(stage,
							 Player.PlayerType.PLAYER_TWO,
							 Player.InputType.KEYBOARD_TWO);
		add(player2);
		add(player2.arrowSprite);

		activeHitboxes = new List<Hitbox>();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		// remove stale hitboxes/attacks
		player1.removeStale();
		player2.removeStale();

		// do collision


		// tick
		player1.tick();
		player2.tick();
	}

	public function activateHitbox(hitbox:Hitbox) {
		hitbox.player.activeHitboxes.add(hitbox);
		add(hitbox.sprite);
	}
}
