package {
	import Box2DAS.Dynamics.b2World;
	
	import flash.display.BitmapData;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;

	public class BigPlayer extends FlxSprite {
		[Embed( source="../resources/gfx/head-16x26.png" )]
		private var ImgHead:Class;
		
		[Embed( source="../resources/gfx/torso-16x16.png" )]
		private var ImgTorso:Class;
		
		[Embed( source="../resources/gfx/arm-4x14.png" )]
		private var ImgArm:Class;
		
		[Embed( source="../resources/gfx/leg-4x8.png" )]
		private var ImgLeg:Class;
		
		protected var body:PhysicalBody = new PhysicalBody();
		protected static var collisionGroupIndex:int = -1;
		
		public var buffer:BitmapData;
		
		public static var radInDeg:Number = 180.0 / Math.PI;
		
		public function BigPlayer( x:int, y:int, world:b2World ) {
			super( x, y, null );
			
			buffer = new BitmapData( Main.WIDTH, Main.HEIGHT, true, 0x00000000 );
			
			body.withWorld( world ).withFiltering( Main.MAN_CATEGORY_BITS, Main.MAN_CATEGORY_BITS | Main.FLOOR_CATEGORY_BITS |
				Main.CRATE_CATEGORY_BITS, --collisionGroupIndex );
			
			body.
				withMaterial( 2.0, 1.0, 0.01 ).
					addLimb( "rightArm", 4, 14, null, x + 6, y + 2, ImgArm ).
				withMaterial( 1.0, 1.0, 0.01 ).
					addLimb( "torso", 16, 16, null, x, y, ImgTorso ).
				withMaterial( 2.0, 1.0, 0.01 ).
					addLimb( "leftLeg", 4, 8, "torso", -6, 12, ImgLeg ).
					addLimb( "rightLeg", 4, 8, "torso", 6, 12, ImgLeg ).
				withMaterial( 1.0, 1.0, 0.01 ).
					addLimb( "head", 16, 26, null, x, y - 18, ImgHead ).
				withMaterial( 2.0, 1.0, 0.01 ).
					addLimb( "leftArm", 4, 14, null, x - 6, y + 2, ImgArm );
					
			body.
				addJoint( "torsoLeftArm", "torso", "leftArm", 0, -7, 0, 0, false ).
				addJoint( "torsoRightArm", "torso", "rightArm", 0, -7, 0, 0, false ).
				addJoint( "torsoHead", "torso", "head", 0, 13, -30, 45 ).
				addJoint( "torsoLeftLeg", "torso", "leftLeg", 0, -4, -30, 5 ).
				addJoint( "torsoRightLeg", "torso", "rightLeg", 0, -4, -5, 30 );
		}
		
		override public function update():void {
		}
		
		override public function render():void {
		}
	}
}