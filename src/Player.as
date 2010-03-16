package {
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2World;
	
	import org.flixel.FlxSprite;
	
	import util.b2f;

	public class Player extends FlxSprite {
		[Embed( source="../resources/gfx/crate.png" )]
		private var ImgBox:Class;
		
		[Embed( source="../resources/gfx/head-8x13.png" )]
		private var ImgHead:Class;
		
		[Embed( source="../resources/gfx/torso-8x8.png" )]
		private var ImgTorso:Class;
		
		[Embed( source="../resources/gfx/pelvis.png" )]
		private var ImgPelvis:Class;
		
		[Embed( source="../resources/gfx/arm-2x7.png" )]
		private var ImgArm:Class;
		
		[Embed( source="../resources/gfx/forearm.png" )]
		private var ImgForearm:Class;
		
		[Embed( source="../resources/gfx/leg-2x4.png" )]
		private var ImgLeg:Class;
		
		public static var radInDeg:Number = 180.0 / Math.PI;
		
		private var bodySprites:Vector.<FlxSprite> = new Vector.<FlxSprite>();
		
		protected var body:PhysicalBody = new PhysicalBody();
		private var weapon:PhysicalBody = new PhysicalBody();
		
		protected static var collisionGroupIndex:int = -1;
		
		public static var conscious:Boolean = true;
		public static var canJump:Boolean = false;
		
		public function Player( x:int, y:int, world:b2World ) {
			super( x, y, null );
			
			// FIXME: Fix origins for sprites (to match joints and limbs)
			
			// adding body sprites
			/* var leftArmSprite:FlxSprite = new NullSprite( "leftArm", x - 4, y - 0.5, ImgArm );
			bodySprites.push( leftArmSprite );
			PlayState.instance.add( leftArmSprite );
			var leftForearmSprite:FlxSprite = new NullSprite( "leftForearm", leftArmSprite.x + 0, leftArmSprite.y + 3, ImgForearm );
			bodySprites.push( leftForearmSprite );
			PlayState.instance.add( leftForearmSprite );
			var headSprite:FlxSprite = new NullSprite( "head", x, y - 5, ImgHead );
			bodySprites.push( headSprite );
			PlayState.instance.add( headSprite );
			var torsoSprite:FlxSprite = new NullSprite( "torso", x, y, ImgTorso );
			bodySprites.push( torsoSprite );
			PlayState.instance.add( torsoSprite );
			var pelvisSprite:FlxSprite = new NullSprite( "pelvis", torsoSprite.x + 0, torsoSprite.y + 3, ImgPelvis );
			bodySprites.push( pelvisSprite );
			PlayState.instance.add( pelvisSprite );
			var leftLegSprite:FlxSprite = new NullSprite( "leftLeg", pelvisSprite.x - 3, pelvisSprite.y + 2, ImgLeg );
			bodySprites.push( leftLegSprite );
			PlayState.instance.add( leftLegSprite );
			var rightLegSprite:FlxSprite = new NullSprite( "rightLeg", pelvisSprite.x + 3, pelvisSprite.y + 2, ImgLeg );
			bodySprites.push( rightLegSprite );
			PlayState.instance.add( rightLegSprite );
			var rightArmSprite:FlxSprite = new NullSprite( "rightArm", x + 3, y - 0.5, ImgArm );
			bodySprites.push( rightArmSprite );
			PlayState.instance.add( rightArmSprite );
			var rightForearmSprite:FlxSprite = new NullSprite( "rightForearm", rightArmSprite.x + 0, rightArmSprite.y + 3, ImgForearm );
			bodySprites.push( rightForearmSprite );
			PlayState.instance.add( rightForearmSprite ); */
			
			body.withWorld( world ).withFiltering( Main.MAN_CATEGORY_BITS, Main.MAN_CATEGORY_BITS | Main.FLOOR_CATEGORY_BITS |
				Main.CRATE_CATEGORY_BITS, collisionGroupIndex );
			// adding limbs
			/* body.
				withMaterial( 2.0, 1.0, 0.01 ).
					addLimb( "leftArm", 2, 7, null, x - 3, y + 0.5, ImgArm ).
				withMaterial( 1.0, 1.0, 0.01 ).
					addLimb( "head", 8, 13, null, x, y - 8.5, ImgHead ).
				withMaterial( 1.0, 1.0, 0.01 ).
					addLimb( "torso", 8, 8, null, x, y, ImgTorso ).
				withMaterial( 2.0, 1.0, 0.01 ).
					addLimb( "leftLeg", 2, 4, "torso", -3, 6, ImgLeg ).
					addLimb( "rightLeg", 2, 4, "torso", 3, 6, ImgLeg ).
				withMaterial( 2.0, 1.0, 0.01 ).
					addLimb( "rightArm", 2, 7, null, x + 3, y + 0.5, ImgArm ); */
			/* body.
				withMaterial( 2.0, 1.0, 0.01 ).
					addLimb( "rightArm", 2, 7, null, x + 3, y + 1, ImgArm ).
				withMaterial( 1.0, 1.0, 0.01 ).
					addLimb( "torso", 8, 8, null, x, y, ImgTorso ).
				withMaterial( 2.0, 1.0, 0.01 ).
					addLimb( "leftLeg", 2, 4, "torso", -3, 6, ImgLeg ).
					addLimb( "rightLeg", 2, 4, "torso", 3, 6, ImgLeg ).
				withMaterial( 1.0, 1.0, 0.01 ).
					addLimb( "head", 8, 13, null, x, y - 8.5, ImgHead ).
				withMaterial( 2.0, 1.0, 0.01 ).
					addLimb( "leftArm", 2, 7, null, x - 3, y + 1, ImgArm ); */
				
			// TODO: add ground sensor "limb"
			// adding joints
			/* body.
				addJoint( "torsoLeftArm", "torso", "leftArm", 0, -3.5, 0, 0, false ).
				addJoint( "torsoRightArm", "torso", "rightArm", 0, -3.5, 0, 0, false ).
				addJoint( "torsoHead", "torso", "head", 0, 6.5, -10, 25 ).
				addJoint( "torsoLeftLeg", "torso", "leftLeg", 0, -2, -30, 5 ).
				addJoint( "torsoRightLeg", "torso", "rightLeg", 0, -2, -5, 30 ); */
		}
		
		override public function update():void {
			/* for each ( var limb:Limb in body.getLimbs() ) {
				var body:b2Body = limb.body;
				limb.x = b2f( body.GetPosition().x );
				limb.y = b2f( body.GetPosition().y );
				limb.angle = ( body.GetAngle() ) * radInDeg;
			} */ 
		}
		
		override public function render():void {
			// No draw
			// super.render();
		}
	}
}
