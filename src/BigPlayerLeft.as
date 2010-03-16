package {
	import Box2DAS.Dynamics.b2World;
	
	import org.flixel.FlxSprite;
	
	public class BigPlayerLeft extends FlxSprite {
		[Embed( source="../resources/gfx/head-conscious-16x26.png" )]
		private var ImgHead:Class;
		
		[Embed( source="../resources/gfx/body-left-24x24.png" )]
		private var ImgBodyLeft:Class;
		
		[Embed( source="../resources/gfx/arm-for-gun-4x8.png" )]
		private var ImgArm:Class;
		
		[Embed( source="../resources/gfx/forearm-for-gun-4x4.png" )]
		private var ImgForearm:Class;
		
		[Embed( source="../resources/gfx/gun-left-24x12.png" )]
		private var ImgGunLeft:Class;
		
		protected var body:PhysicalBody = new PhysicalBody();
		protected static var collisionGroupIndex:int = -1;
		
		public static var radInDeg:Number = 180.0 / Math.PI;
		
		public function BigPlayerLeft( x:int, y:int, world:b2World ) {
			super( x, y, null );
			
			body.withWorld( world ).withFiltering( Main.MAN_CATEGORY_BITS, Main.MAN_CATEGORY_BITS | Main.FLOOR_CATEGORY_BITS |
				Main.CRATE_CATEGORY_BITS, --collisionGroupIndex );
			
			body.
				withMaterial( 2.0, 1.0, 0.01 ).
					addLimb( "rightArm", 4, 14, null, x + 6, y - 2, ImgArm ).
				withMaterial( 1.0, 1.0, 0.01 ).
					addLimb( "body", 16, 24, null, x, y, ImgBodyLeft, 0, 0, true ).
				withMaterial( 1.0, 1.0, 0.01 ).
					addLimb( "head", 16, 26, null, x, y - 22, ImgHead ).
				withMaterial( 2.0, 1.0, 0.01 ).
					addLimb( "leftArm", 4, 14, null, x - 6, y - 2, ImgArm ).
				withMaterial( 3.0, 1.0, 0.01 ).
					addLimb( "gun", 24, 12, null, x + 6, y - 4, ImgGunLeft );
					
			body.
				addJoint( "torsoLeftArm", "body", "leftArm", 0, -7, 0, 0, false ).
				addJoint( "torsoRightArm", "body", "rightArm", 0, -7, 0, 0, false ).
				addJoint( "torsoHead", "body", "head", 0, 13, 0, 0 ).
				addJoint( "torsoGun", "body", "gun", -14, -8, 0, 0, false );
		}
		
		override public function update():void {
		}
		
		override public function render():void {
		}
	}
}
